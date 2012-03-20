/* CMap3D. A 3D Comparative Map Viewer.
 * 
 * A viewer for viewing and comparing genetic(linkage)/physical/sequence maps, using
 * annotations or 'features' (such as SSR/RFLP/SNP/etc markers) to map common aspects
 * between the maps. See (http://www.gmod.org/wiki/index.php/CMap) for details on the
 * original 2D comparative mapping software.
 *
 * Version 0.7
 *
 * This software is available through the following channels:
 * http://chrisduran.co/
 * https://github.com/chrisduran/CMap3D/
 * http://
 *
 * Copyright (c) 2008  Chris Duran
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.

 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.

 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * https://github.com/chrisduran/CMap3D/blob/master/LICENCE
 *
 * Email: c.duran@uqconnect.edu.au
 * Web: http://chrisduran.co/
 */
 

Knob rotationControl;
Slider inclineControl, zoomControl;
controlP5.Button resetControl, repositorySelect, addMap, cancelAddMap;
Bang upControl, downControl, leftControl, rightControl;
Textlabel objectMoveControl;
Textlabel repositoryNameLabel, repositoryWebsiteLabel,repositoryWebsite, repositoryDescLabel;
Textarea repositoryName, repositoryDesc;
Textarea toolTip;
ControlGroup navigation, repositoryDetails, mapListGroup, typeListGroup;
Toggle [] mapListToggles, mapListRotateToggles, typeListToggles;
controlP5.Button [] mapListRemove;
Textlabel [] mapListNames;
Textlabel [] typeListNames;
ScrollList repositoryListDisplay;

RepositoryListListener repositoryListener;
TypeListListener typeListener;
MapListListener mapListener;
MapListRotationListener mapRotationListener;
MapListRemoveListener mapRemoveListener;
SpeciesListListener speciesListListener;
MapSetListListener mapSetListListener;
MapsListListener mapsListListener;

ControlWindow addMapWindow;
ScrollList speciesList, mapSetList, mapsList;

void initTypeListControllers() {
  typeListGroup = controlP5.addGroup("typelist",15,70,185);
  typeListToggles = new Toggle[typeList.length];
  typeListNames = new Textlabel[typeList.length];
  
  if (typeList.length > 0) {
    for (int i = 0; i < typeList.length; i++) {
      typeListToggles[i] = controlP5.addToggle("typevisible"+i,1,5+15*i,10,10);
      typeListToggles[i].setId(i);
      typeListToggles[i].setGroup(typeListGroup);
      typeListToggles[i].setColorForeground(backgroundControl);
      typeListToggles[i].setColorActive(typeColour[i%8]);
      typeListToggles[i].setLabel("");
      typeListToggles[i].setState(true);
      typeListToggles[i].addListener(typeListener);
      typeListNames[i] = controlP5.addTextlabel("typelabel"+i,typeList[i],18,6+15*i);
      typeListNames[i].setGroup(typeListGroup);
    }
  }
}

void initMapListControllers () {
  mapListGroup = controlP5.addGroup("maplist",15,200,185);
  mapListToggles = new Toggle[mapList.length];
  mapListRotateToggles = new Toggle[mapList.length];
  mapListRemove = new controlP5.Button[mapList.length];
  mapListNames = new Textlabel[mapList.length];
  mapListener = new MapListListener();
  mapRotationListener = new MapListRotationListener();
  mapRemoveListener = new MapListRemoveListener();
  
  if (mapList.length > 0) {
    for (int i = 0; i < mapList.length; i++) {
    
      //VISIBILITY TOGGLES
      mapListToggles[i] = controlP5.addToggle("visible"+mapList[i],1,25+15*i,10,10);
      mapListToggles[i].setId(i);
      mapListToggles[i].setGroup(mapListGroup);
      mapListToggles[i].setColorForeground(backgroundControl);
      mapListToggles[i].setLabel("");
      mapListToggles[i].addListener(mapListener);
      mapListToggles[i].setState(true);
    
      //ROTATIONAL TOGGLES
      mapListRotateToggles[i] = controlP5.addToggle("rotate"+mapList[i],18,25+15*i,10,10);
      mapListRotateToggles[i].setId(i);
      mapListRotateToggles[i].setGroup(mapListGroup);
      mapListRotateToggles[i].setColorForeground(backgroundControl);
      mapListRotateToggles[i].setLabel("");
      mapListRotateToggles[i].addListener(mapRotationListener);
      mapListRotateToggles[i].setState(false);
      
      //REMOVE BUTTONS
      mapListRemove[i] = controlP5.addButton("remove"+mapList[i],0,35,25+15*i,10,10);
      mapListRemove[i].setId(i);
      mapListRemove[i].setGroup(mapListGroup);
      mapListRemove[i].setColorActive(#FF0000);
      mapListRemove[i].setLabel("");
      mapListRemove[i].addListener(mapRemoveListener);
    
      mapListNames[i] = controlP5.addTextlabel("label"+mapList[i],( (CMap)(mapLookup.get(mapList[i])) ).mapName,54,26+15*i);
      mapListNames[i].setGroup(mapListGroup);
    }
  }
  
  addMap = controlP5.addButton("addmap",0,1,25+15*mapList.length,100,10);
  addMap.setLabel("add another map...");
  addMap.setGroup(mapListGroup);
}

void configureControllers() {
  //Setting of Camera Control Panel
  controlP5 = new ControlP5(this);
  controlP5.setColorBackground(backgroundControl);
  controlP5.setColorForeground(activeControl);
  controlP5.setColorActive(activeControl);
  toolTip = controlP5.addTextarea("toolTip","",0,0,100,50);
  toolTip.setColorBackground(#FF0000);
  toolTip.setVisible(false);
  repositoryListener = new RepositoryListListener();
  speciesListListener = new SpeciesListListener();
  mapSetListListener = new MapSetListListener();
  mapsListListener = new MapsListListener();
  typeListener = new TypeListListener();
}

void initAddMapWindow () {
  //addMapWindow = controlP5.addControlWindow("addmapwindow",800,400);
  speciesList = controlP5.addScrollList("specieslist",100,150,180,360);
  //speciesList.setTab(addMapWindow,"default");
  mapSetList = controlP5.addScrollList("mapsetlist",330,150,260,360);
  //mapSetList.setTab(addMapWindow,"default");
  mapsList = controlP5.addScrollList("mapslist",630,150,260,360);
  //mapsList.setTab(addMapWindow,"default");
  cancelAddMap = controlP5.addButton("canceladdmap",0,740,530,150,20);
  cancelAddMap.setLabel("Cancel");
}

void addSpeciesList () {
  speciesList.remove();
  speciesList = controlP5.addScrollList("specieslist",100,150,180,360);
  //speciesList.setTab(addMapWindow,"default");
}

void addMapSetList () {
  mapSetList.remove();
  mapSetList = controlP5.addScrollList("mapsetlist",330,150,260,360);
  //mapSetList.setTab(addMapWindow,"default");  
}

void addMapsList () {
  mapsList.remove();
  mapsList = controlP5.addScrollList("mapslist",630,150,260,360);
  //mapsList.setTab(addMapWindow,"default");
}

void initNavigationControllers () {
  
  //NAVIGATION GROUP
  navigation = controlP5.addGroup("navigation",15,340,185);
  inclineControl = controlP5.addSlider("inclinecontroller",-(INCLINE_RANGE-1),INCLINE_RANGE-1,0,25,150,20,40);
  rotationControl = controlP5.addKnob("rotationcontroller",0,359,0,74,150,40);
  zoomControl = controlP5.addSlider("zoomcontroller",-zoomFactorMax,-zoomFactorMin,-ZOOMFACTOR_DEFAULT,140,150,20,40);
  resetControl = controlP5.addButton("resetcontroller",0,25,215,135,20);
  upControl = controlP5.addBang("moveupcontroller",76,18,33,33);
  downControl = controlP5.addBang("movedowncontroller",76,84,33,33);
  leftControl = controlP5.addBang("moveleftcontroller",43,51,33,33);
  rightControl = controlP5.addBang("moverightcontroller",109,51,33,33);
  
  objectMoveControl = controlP5.addTextlabel("movecontroller","MOVE OBJECT",68,125);
  objectMoveControl.setFont(ControlP5.standard58);
  zoomControl.setLabel("Zoom");
  inclineControl.setSliderMode(Slider.FLEXIBLE);
  inclineControl.setLabel("Incline");
  rotationControl.setLabel("Rotate");
  resetControl.setLabel("RESET CAMERA");
  inclineControl.setGroup(navigation);
  rotationControl.setGroup(navigation);
  zoomControl.setGroup(navigation);
  resetControl.setGroup(navigation);
  objectMoveControl.setGroup(navigation);
  upControl.setGroup(navigation);
  downControl.setGroup(navigation);
  leftControl.setGroup(navigation);
  rightControl.setGroup(navigation);
  upControl.setColorForeground(backgroundControl);
  downControl.setColorForeground(backgroundControl);
  leftControl.setColorForeground(backgroundControl);
  rightControl.setColorForeground(backgroundControl);
  upControl.setLabel("");
  downControl.setLabel("");
  leftControl.setLabel("");
  rightControl.setLabel("");
  navigation.setVisible(false);
}

void initRepositoryControllers () {
  //REPOSITORY COLLECTION
  repositoryListDisplay = controlP5.addScrollList("repositorycontroller",150,150,150,400);
  repositoryListDisplay.setLabel("select a repository:");
  
  
 repositoryDetails = controlP5.addGroup("repository details",350,150,500);
   
  repositoryNameLabel = controlP5.addTextlabel("repositorynamelabel","NAME:",10,23);
  repositoryName = controlP5.addTextarea("repositoryname","filler",150,20,320,20);
  repositoryWebsiteLabel = controlP5.addTextlabel("repositorywebsitelabel","WEBSITE:",10,53);
  repositoryWebsite = controlP5.addTextlabel("repositorywebsite","http://thewebsite.com",150,53);
  repositoryDescLabel = controlP5.addTextlabel("repositorydesclabel","DESCRIPTION:",10,83);
  repositoryDesc = controlP5.addTextarea("repositorydesc","http://thewebsite.com",150,80,320,150);
  repositorySelect = controlP5.addButton("repositoryselect",0,150,250,320,25);
  
  repositoryWebsite.setColorValue(hyperlinkText);
  repositoryName.setColor(contentText);
  repositoryDesc.setColor(contentText);
  repositorySelect.setLabel("SELECT THIS REPOSITORY");
  
  repositoryNameLabel.setGroup("repository details");
  repositoryName.setGroup("repository details");
  repositoryWebsiteLabel.setGroup("repository details");
  repositoryWebsite.setGroup("repository details");
  repositoryDescLabel.setGroup("repository details");
  repositoryDesc.setGroup("repository details");
  repositorySelect.setGroup("repository details");
  
  repositoryListDisplay.setVisible(false);
  repositoryDetails.setVisible(false);
}

void inclinecontroller(int theValue) {
  incline = theValue; 
}

void rotationcontroller(int theValue) {
  rotation = 359-theValue;
}

void zoomcontroller(float theValue) {
  zoomFactor = -theValue;
}

void resetcontroller() {
  resetEngine();
} 

void moveupcontroller() {
  worldObjectMove('v', -5);
}

void movedowncontroller() {
  worldObjectMove('v', 5);
}

void moveleftcontroller() {
  worldObjectMove('h', -5);
}

void moverightcontroller() {
  worldObjectMove('h', 5);
}

void changeRepository() {
      repositoryName.setText(repositoryList[currentRepository][1]);
      repositoryWebsite.setValue(repositoryList[currentRepository][2]);
      repositoryDesc.setText(repositoryList[currentRepository][3].replace('~','\n'));
}

void repositoryselect() {
  drawStage = 4;
  tabNav = loadImage("tab_nav_maps.png");
}

void addmap() {
  drawStage = 9;
  addMapStage = 1;
}

void canceladdmap() {
  addMapStage = 0;
  drawStage = 18;
}

class RepositoryListListener implements ControlListener {
  public void controlEvent(ControlEvent theEvent) {
    currentRepository = int(theEvent.controller().value());
    changeRepository();
    theEvent.controller().parent().setColorBackground(backgroundControl);
    theEvent.controller().parent().setColorLabel(#FFFFFF);
    theEvent.controller().setColorBackground(activeControl);
    theEvent.controller().setColorLabel(0);
  }
}

class MapListListener implements ControlListener {
  public void controlEvent(ControlEvent theEvent) {
     if (theEvent.controller().value() == 1.0) {
          ( (CMap)(mapLookup.get(mapList[theEvent.controller().id()])) ).isVisible = true;
          
        } else if (theEvent.controller().value() == 0.0) {
          ( (CMap)(mapLookup.get(mapList[theEvent.controller().id()])) ).isVisible = false;
        }
  }
}

class MapListRotationListener implements ControlListener {
  public void controlEvent(ControlEvent theEvent) {
     if (theEvent.controller().value() == 1.0) {
          ( (CMap)(mapLookup.get(mapList[theEvent.controller().id()])) ).isReversed = true;
          
        } else if (theEvent.controller().value() == 0.0) {
          ( (CMap)(mapLookup.get(mapList[theEvent.controller().id()])) ).isReversed = false;
        }
  }
}

class MapListRemoveListener implements ControlListener {
  public void controlEvent(ControlEvent theEvent) {
    String [] tempMapList = new String [mapList.length];
    arraycopy(mapList, tempMapList);
    mapList = shorten(mapList);
    arraycopy(tempMapList,0,mapList,0,theEvent.controller().id());
    arraycopy(tempMapList,theEvent.controller().id()+1,mapList,theEvent.controller().id(),tempMapList.length-(theEvent.controller().id()+1));
    
    drawStage = 19;
  }
}

class SpeciesListListener implements ControlListener {
  public void controlEvent(ControlEvent theEvent) {
    speciesListCurrent = speciesListAcc[int(theEvent.controller().value())];
    theEvent.controller().parent().setColorBackground(backgroundControl);
    theEvent.controller().parent().setColorLabel(#FFFFFF);
    theEvent.controller().setColorBackground(activeControl);
    theEvent.controller().setColorLabel(0);
    addMapStage = 10;
  }
}

class MapSetListListener implements ControlListener {
  public void controlEvent(ControlEvent theEvent) {
    mapSetListCurrent = mapSetListAcc[int(theEvent.controller().value())];
    theEvent.controller().parent().setColorBackground(backgroundControl);
    theEvent.controller().parent().setColorLabel(#FFFFFF);
    theEvent.controller().setColorBackground(activeControl);
    theEvent.controller().setColorLabel(0);
    addMapStage = 15;
  }
}

class MapsListListener implements ControlListener {
  public void controlEvent(ControlEvent theEvent) {
    mapList = append(mapList, mapsListAcc[int(theEvent.controller().value())]);
    addMapStage = 0;
    drawStage = 18;
  }
}

class TypeListListener implements ControlListener {
  public void controlEvent(ControlEvent theEvent) {
    if (theEvent.controller().value() == 1.0) {
          for (int i = 0; i < mapList.length; i++) {
            if (singularTyped.get(mapList[i]+":"+typeList[theEvent.controller().id()]) != null) {
              //println(((String[])(singularTyped.get(mapList[i]+":"+typeList[theEvent.controller().id()]))));
              for (int j = 0; j < ((String[])(singularTyped.get(mapList[i]+":"+typeList[theEvent.controller().id()]))).length; j++) {
                ((Feature)(featureLookup.get(((String[])(singularTyped.get(mapList[i]+":"+typeList[theEvent.controller().id()])))[j])) ).visible = true;
              }
            }
            if (rangedTyped.get(mapList[i]+":"+typeList[theEvent.controller().id()]) != null) {
              //println(((String[])(rangedTyped.get(mapList[i]+":"+typeList[theEvent.controller().id()]))));
              for (int j = 0; j < ((String[])(rangedTyped.get(mapList[i]+":"+typeList[theEvent.controller().id()]))).length; j++) {
                ((Feature)(featureLookup.get(((String[])(rangedTyped.get(mapList[i]+":"+typeList[theEvent.controller().id()])))[j])) ).visible = true;
              }
            }
          }
          
        } else if (theEvent.controller().value() == 0.0) {
          for (int i = 0; i < mapList.length; i++) {
            if (singularTyped.get(mapList[i]+":"+typeList[theEvent.controller().id()]) != null) {
              //println(((String[])(singularTyped.get(mapList[i]+":"+typeList[theEvent.controller().id()]))));
              for (int j = 0; j < ((String[])(singularTyped.get(mapList[i]+":"+typeList[theEvent.controller().id()]))).length; j++) {
                ((Feature)(featureLookup.get(((String[])(singularTyped.get(mapList[i]+":"+typeList[theEvent.controller().id()])))[j])) ).visible = false;
              }
            }
            if (rangedTyped.get(mapList[i]+":"+typeList[theEvent.controller().id()]) != null) {
              //println(((String[])(rangedTyped.get(mapList[i]+":"+typeList[theEvent.controller().id()]))));
              for (int j = 0; j < ((String[])(rangedTyped.get(mapList[i]+":"+typeList[theEvent.controller().id()]))).length; j++) {
                ((Feature)(featureLookup.get(((String[])(rangedTyped.get(mapList[i]+":"+typeList[theEvent.controller().id()])))[j])) ).visible = false;
              }
            }
          }
        }
  }
}
