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
 
 
import java.util.HashMap;
import java.util.LinkedList;
  

import controlP5.*;
import proxml.*;

//CONSTANTS
final int ROTATION_DEFAULT = 0;
final int INCLINE_DEFAULT = 0;
final float ZOOMFACTOR_DEFAULT = 1.0;
final int ROTATION_RANGE = 360; //one direction
final int INCLINE_RANGE = 31; //both directions (ie: 1-90, 30 means 30 up, 30 down).
final float BASE_ZOOM = 600.0;
final int FEATURE_SCALE_BASE = 6000;
final String VERSION = "0.7";

//=================================================================================== 
//  GLOBAL VARIABLES
//===================================================================================

float zoomFactor = ZOOMFACTOR_DEFAULT;    //is how close/far to the object we are (1 at cage, 0 at object).

int rotation = ROTATION_DEFAULT;
int incline = INCLINE_DEFAULT;

String [] mapList;
String [] typeList;
String [][] repositoryList;
float [] tierPopulate;
//String repositoryURL;

boolean globalHasCorres;

int totalMapCount;

HashMap mapLookup;
HashMap featureLookup;
HashMap singularTyped;
HashMap rangedTyped;
HashMap trackLookup;

ControlP5 controlP5;

MapArranger mapPositions;
LinkedList drawTable;
LinkedList focusedFeatures;
CorrespondenceClass correspondence;

//constraints
float zoomFactorMin = 0.2;
float zoomFactorMax = 2.0;


int mouseSensitivity = 2;
float scrollWheelSensitivity = 0.01;

int engineOffset = 200;
int drawStage = -1;
int addMapStage = 0;
int currentRepository = 0;
int loadingCount = 0;

//3D Engine... default 2D engine acts as an overlay
PGraphics engine;
P5Properties config;

// FONTS
PFont font8;
PFont font10;
PFont font12;
PFont fontTitle;
PFont currentRepositoryFont;
PFont messageFont;
PFont tooltipFont, tooltipFontBold;

//CONTROLS

proxml.XMLElement cmapdata;
proxml.XMLElement currentElement;
proxml.XMLElement XMLtype;
proxml.XMLElement XMLmap;
proxml.XMLElement XMLfeature;
proxml.XMLElement XMLcorres;
XMLInOut xmlParser;

String currentXMLmap;
String currentXMLtype;
String repositoryError = "";
String [] currentRepositoryEngine;
String [] speciesListAcc, speciesListName, mapSetListAcc, mapsListAcc;
String speciesListCurrent, mapSetListCurrent, mapsListCurrent;
String repositoryURL = "http://www.wheatgenome.info/cmap3d/repositories.xml";

color backgroundControl = #333333;
color activeControl = #feb601;
color panelColour = #666666;

color labelText = #FFFFFF;
color contentText = #999988;
color hyperlinkText = #3333FF;

// pure green, pure cyan, pure yellow-orange, pure violet-magenta, light warm brown, pure blue, pure magenta, pastel yellow
color [] typeColour = {#00a651,#00aeef,#f7941d,#92278f,#a67c52,#0054a6,#ec008c,#fff799};

color correspondenceColour = #FF0000;
color correspondenceLineColour = #662222;
color mapColour = #999988;
color defaultColour = #CCCCCC;
color featureDefaultColour = #6699DD;
color highlightColour = #FFFF00;
color selectedColour = #FFFF00;
color tooltipBackground = color(64, 200);

// map fonts
String sfont8 = "LucidaSans-Typewriter-8.vlw";
String sfont10 = "LucidaSans-Typewriter-10.vlw";
String sfont12 = "LucidaSans-Typewriter-12.vlw";


PImage tabWindow, tabNav, engineWindow, version;
PImage [] loading;
PImage rotateIcon, removeIcon, visibleIcon;
PImage acpfgLogo, qfabLogo, uqLogo;

String mapA, mapB, featA, featB;
float x1, x2, y1, y2, thisDist, thisFeatureScale;

// UI fonts

//FUNCTIONAL
int xPressed;
int yPressed;
boolean clicked;

// initial coordinates for the object anchor. Changing these coords will move all objects
// in the 3 dimensional space. Powerful stuff.
float anchorX = 0;
float anchorY = 0;
float anchorZ = 0;
float lineHeight = 400;

// variables to store the current camera location, used for UI scaling.
float cameraX = 0;
float cameraY = 0;
float cameraZ = BASE_ZOOM;


//=================================================================================== 
//  SYSTEM INITIALIZATION
//===================================================================================

void setup() {
  
  //Setting the initial environment. The 3D environment is smaller than the 2D. This
  // is to allow a 'control panel' on the side of the program.
  size (1000,600);
  
  smooth();
  engine = createGraphics(800,600, P3D);
  frameRate(30);
  
  processConfigFile();
  
  configureControllers();
  
  clicked = false;
  
  //Collection variables
  mapLookup = new HashMap();
  featureLookup = new HashMap();
  singularTyped = new HashMap();
  rangedTyped = new HashMap();
  trackLookup = new HashMap();
  drawTable = new LinkedList();
  focusedFeatures = new LinkedList();
  correspondence = null;
  globalHasCorres = false;
  
  //Adds a Listener service for the mouseWheel as Processing does have a default
  //listener for mouse wheel movement. The mouseWheel changes the zoomFactor.
  //Listener also keeps the min/max for the zoom in check.
  frame.addMouseWheelListener(
    new java.awt.event.MouseWheelListener() {
       public void mouseWheelMoved (java.awt.event.MouseWheelEvent evt) {
         if (mouseX > engineOffset && drawStage == 30) {
           if (evt.getWheelRotation()<0) {
             engineZoom('o',evt.getScrollAmount() * scrollWheelSensitivity);
           } else {
             engineZoom('i',evt.getScrollAmount() * scrollWheelSensitivity);
           } 
           if (zoomFactor < zoomFactorMin) {
             zoomFactor = zoomFactorMin;
           } else if (zoomFactor > zoomFactorMax) {
             zoomFactor = zoomFactorMax; 
           }
         }
       }
    }
  );

  font8 = loadFont(sfont8);
  font10 = loadFont(sfont10);
  font12 = loadFont(sfont12);
  fontTitle = loadFont("fontTitle.vlw");
  messageFont = loadFont("message.vlw");
  tooltipFont = loadFont("tooltipFont.vlw");
  tooltipFontBold = loadFont("tooltipFontBold.vlw");
  
  currentRepositoryFont = loadFont("selected_repository.vlw");
  tabNav = loadImage("tab_nav_welcome.png");
  
  rotateIcon = loadImage("rotate.png");
  removeIcon = loadImage("remove.png");
  visibleIcon = loadImage("visible.png");
  tabWindow = loadImage("tab_window.png");
  engineWindow = loadImage("engine_window.png");
  version = loadImage("version.png");
  
  acpfgLogo = loadImage("acpfg.gif");
  qfabLogo = loadImage("qfab.gif");
  uqLogo = loadImage("uq.png");
  
  loading = new PImage[31];
  
  for (int i = 0; i <= 30; i++) {
    loading[i] = loadImage("loading/loading00"+(i+1)+".png");
  }
  
  xmlParser = new XMLInOut(this);
}


//=================================================================================== 
// *** MAIN PROGRAM ***
//===================================================================================

void draw() {
  smooth();
  //draw 2D environment
  background(#111111);
  
  
  switch(drawStage) {
    case -2:
      drawStage = 0;
    break;
    case -1: //Intro-page
      cursor(ARROW);
      noStroke();
      image(tabWindow,0,0);
      image(tabNav,0,0);
      image(version,26,543);
      image(acpfgLogo,650,11);
      textFont(messageFont);
      fill(activeControl);
      textAlign(LEFT);
      text("CMap3D: A 3D visualization tool for comparative genetic maps",50,100);
      float titleWidth = textWidth("CMap3D: A 3D visualization tool for comparative genetic maps");
      textFont(currentRepositoryFont);
      fill(mapColour);
      text("A viewer for viewing and comparing genetic(linkage)/physical/sequence maps, using "+
           "annotations or 'features' (such as SSR/RFLP/SNP/etc markers) to map common aspects "+
           "between the maps. See (http://www.gmod.org/wiki/index.php/CMap) for details on the "+
           "original 2D comparative mapping software."+
           "\n\n"+
           "Copyright (c) 2008  Chris Duran"+
           "\n\n"+
           "This program is free software: you can redistribute it and/or modify "+
           "it under the terms of the GNU General Public License as published by "+
           "the Free Software Foundation, either version 3 of the License, or "+
           "(at your option) any later version."+
           "\n\n"+
           "This program is distributed in the hope that it will be useful, "+
           "but WITHOUT ANY WARRANTY; without even the implied warranty of "+
           "MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the "+
           "GNU General Public License for more details."+
           "\n\n"+
           "You should have received a copy of the GNU General Public License "+
           "along with this program.  If not, see <http://www.gnu.org/licenses/>.",50,120,900,270);
      

      fill(backgroundControl);
      rect(350,403,300,40);
      noStroke();
      fill(activeControl);
      if (mouseX>350 && mouseX<650 && mouseY>353 && mouseY<393) {
        fill(labelText);
        cursor(HAND);
        if (mousePressed) {
          drawStage = -2;
        }
      }
      textFont(messageFont);
      textAlign(CENTER);
      text("START USING CMAP3D",500,430);
      
      textFont(currentRepositoryFont);
      fill(correspondenceColour);
      text(repositoryError,500,410);
      
      fill(mapColour);
      text("In association with:",500,490);
      fill(mapColour);
      image(qfabLogo,219,500);
      image(uqLogo,569,500);
    
    break;
    case 0: //LOAD THE REPOSITORY LIST
      try {
        repositoryError = "";
        initRepositoryControllers();
        tabNav = loadImage("tab_nav_repository.png");
        println(repositoryURL);
        xmlParser.loadElement(repositoryURL);

        drawStage = 1;
      } catch (Exception e) {
        repositoryError = "Cannot connect to repository listing. Network Error.";
        drawStage = -1;
      }
    break;
    
    case 1: //REPOSITORY LIST LOADING
        loadingImage(500,300);
    break;
      
    case 2: //DISPLAY REPOSITORY LIST
      drawTabWindow();
      repositoryDesc.setHeight(150);
      
      if (mouseX > 500 && mouseX < 500+(6*repositoryList[currentRepository][2].length()) && mouseY > 200 && mouseY < 215) {
        cursor(HAND);
        if (mousePressed) {
          link(repositoryList[currentRepository][2]);
        }
        
      } else {
        cursor(ARROW);
      }
    break;
    
    case 4: //REPOSITORY SELECTED
    calculateCurrentRepositoryEngine();
    drawEngineWindow();
    loadingImage(600,300);
      
      repositoryListDisplay.remove();
      repositoryDetails.remove();
      
      mapList = new String[0];
      typeList = new String[0];
      
      drawStage = 20;
    break;
    
    case 9: //remove the current controllers
       typeListGroup.remove();
       mapListGroup.remove();
       navigation.remove();
       drawStage = 10;
    break;
    
    case 10: //
      drawTabWindow();
      handleAddMap();
      
    break;  
    
    case 18: //ADDED A MAP TO THE MAP LIST
    drawEngineWindow();
    loadingImage(600,300);
    speciesList.remove();
    mapSetList.remove();
    mapsList.remove();
    cancelAddMap.remove();
    drawStage = 20;
    
    case 19: //REMOVED A MAP FROM THE MAP LIST
    drawEngineWindow();
    loadingImage(600,300);
    typeListGroup.remove();
    mapListGroup.remove();
    navigation.remove();
    drawStage = 20;
    break;
    
    case 20: //PROCESS XML 
    try {
        drawEngineWindow();
        loadingImage(600,300);
        initNavigationControllers();
        String urlExt = "?action=get_map_data;";
        for (int i = 0; i < mapList.length; i++) {
          urlExt += "map_acc"+i+"="+mapList[i];
          if (i != mapList.length-1) {
            urlExt += ";";
          }
        }
        //println(repositoryList[currentRepository][4]+urlExt);
        xmlParser.loadElement(repositoryList[currentRepository][4]+urlExt);
        drawStage = 21;
      } catch (Exception e) {println("ERROR LOADING XML");}
    break;
    
    case 21: //WAIT FOR XML PROCESS
      drawEngineWindow();
      loadingImage(600,300);
    break;
    
    case 22: //AFTER SUCCESSFUL XML LOAD
      drawEngineWindow();
      loadingImage(600,300);
      initTypeListControllers();
      initMapListControllers();
      navigation.setVisible(true);
      drawStage = 30;
    break;
    
    case 30: //mAIN SECTION OF THE PROGRAM IS ACTIVE
      if (mapList.length > 0) {
        
      drawEngine();

      } 
      drawEngineWindow();
      image(visibleIcon,15,mapListGroup.position().y()+5);
      image(rotateIcon,32,mapListGroup.position().y()+5);
      image(removeIcon,49,mapListGroup.position().y()+5);
      if (mapList.length == 0) {        
        textAlign(LEFT);        
        textFont(messageFont);
        fill(mapColour);
        text("Getting Started",250,215);   
        textFont(currentRepositoryFont);
        text("This is the viewing engine for CMAP3D's comparative map viewer. To start comparing maps, you first need\n"+ 
             "to add maps to the viewing engine. To add a map, click on the [ADD ANOTHER MAP...] button to the left.",250,235);
        stroke(activeControl);
        strokeCap(SQUARE);
        strokeWeight(6);
        line(140,230,230,230);
        strokeCap(ROUND);
        noStroke();
        fill(activeControl);
        triangle(130,230,150,220,150,240);
      }
    break;
    
  }
  

  
  textFont(font12);
  }
  
void handleAddMap() {
  switch(addMapStage) {
        case 0: //nothing done yet
        
        break;
        
        case 1: //remove the current controllers
          initAddMapWindow();
          addSpeciesList();
          addMapStage = 5;
        break;
        
        case 5: //do the species list
          loadingImage(180,160,20);
          try {
            
            xmlParser.loadElement(repositoryList[currentRepository][4]+"?action=get_species");
            addMapStage = 6;
            } catch (Exception e) {println("ERROR LOADING XML");}
        break;
        
        case 6:
          loadingImage(180,160,20);
        break;
        
        case 7:
          for (int i = 0; i < speciesListName.length; i++) {
          controlP5.Button b = speciesList.addItem(speciesListName[i],i);
          b.addListener(speciesListListener);
          }
          addMapStage = 0;
        break;
        
        case 10: //do the map_set_list
            addMapSetList();
            addMapsList();
            addMapStage = 11;
        break;
        
        case 11:
          loadingImage(440,160,20);
          try {
            String queryBuild = "";
            if (mapList.length>0) {
              for (int i = 0; i < mapList.length;i++) {
                queryBuild += ";ref"+i+"="+mapList[i];
              }
            }
            xmlParser.loadElement(repositoryList[currentRepository][4]+"?action=get_map_sets;species_acc="+speciesListCurrent+queryBuild);
            addMapStage = 12;
            } catch (Exception e) {println("ERROR LOADING XML");}
        break;
        case 12:
            loadingImage(440,160,20);
        break;
        
        case 13:
          for (int i = 0; i < mapSetListAcc.length; i++) {
          controlP5.Button b = mapSetList.addItem(mapSetListAcc[i],i);
          b.addListener(mapSetListListener);
          }
          addMapStage = 0;
        break;
        
        case 15:
          addMapsList();
          addMapStage = 16;
        break;
        
        case 16:
          loadingImage(750,160,20);
          try {
            String queryBuild = "";
            if (mapList.length>0) {
              for (int i = 0; i < mapList.length;i++) {
                queryBuild += ";ref"+i+"="+mapList[i];
              }
            }
            //println(repositoryList[currentRepository][4]+"mapSelection.php?stage=map&map_set_acc="+mapSetListCurrent+queryBuild);
            xmlParser.loadElement(repositoryList[currentRepository][4]+"?action=get_maps;map_set_acc="+mapSetListCurrent+queryBuild);
            //println(repositoryList[currentRepository][4]+"?action=get_maps;map_set_acc="+mapSetListCurrent+queryBuild);
            addMapStage = 17;
            } catch (Exception e) {println("ERROR LOADING XML");}
        break;
        
        case 17:
          loadingImage(750,160,20);
        break;
        
        case 18:
          for (int i = 0; i < mapsListAcc.length; i++) {
            controlP5.Button b = mapsList.addItem(mapsListAcc[i],i);
            b.addListener(mapsListListener);
          }
          addMapStage = 0;
        break;
      }
}

void drawEngine() {
  engine.beginDraw();
  engine.background(#333333); 
  engine.fill(255);
  engine.stroke(255,102,0);
  
  arrayBoundsHandler();
  
  cameraZ = zoomFactor*BASE_ZOOM;

  engine.camera(cameraX,cameraY,cameraZ,0,0,0,0,1,0);
  
  engine.pushMatrix();//1
  
    engine.translate (anchorX, anchorY, anchorZ);
    engine.rotateX (radians(incline));
    engine.rotateY (radians(rotation));
  
  // PART1: GET THE CURRENT SCREEN COORDINATES FOR THE MAP LINES, AND CREATES THE DRAW TABLE
  drawTable.clear();
  focusedFeatures.clear();
  for (int i = 0; i < mapList.length; i++) {
    float thisCoord;          //
    boolean inserted = false; //   USED FOR THE WHILE LOOP BELOW
    int countLL = 1;          //
    float wLoopDistance;      //
    
    engine.pushMatrix();//2
    engine.translate(( (CMap)(mapLookup.get(mapList[i])) ).arrangeX,
                      0,
                      ( (CMap)(mapLookup.get(mapList[i])) ).arrangeZ);
    ( (CMap)(mapLookup.get(mapList[i])) ).distance = wLoopDistance = dist(engine.modelX(0,0,0), engine.modelY(0,0,0), engine.modelZ(0,0,0), cameraX, cameraY, cameraZ);
    
    if (!( (CMap)(mapLookup.get(mapList[i])) ).isReversed) {
      ( (CMap)(mapLookup.get(mapList[i])) ).topX = engine.screenX(0,-(lineHeight/2),0)+engineOffset;
      ( (CMap)(mapLookup.get(mapList[i])) ).topY = engine.screenY(0,-(lineHeight/2),0);
      ( (CMap)(mapLookup.get(mapList[i])) ).botX = engine.screenX(0,lineHeight/2,0)+engineOffset;
      ( (CMap)(mapLookup.get(mapList[i])) ).botY = engine.screenY(0,lineHeight/2,0);
    } else {
      ( (CMap)(mapLookup.get(mapList[i])) ).botX = engine.screenX(0,-(lineHeight/2),0)+engineOffset;
      ( (CMap)(mapLookup.get(mapList[i])) ).botY = engine.screenY(0,-(lineHeight/2),0);
      ( (CMap)(mapLookup.get(mapList[i])) ).topX = engine.screenX(0,lineHeight/2,0)+engineOffset;
      ( (CMap)(mapLookup.get(mapList[i])) ).topY = engine.screenY(0,lineHeight/2,0);
    }
    
    

    if (i == 0) {
      drawTable.add(mapList[i]);
    } else if ( wLoopDistance <= ( (CMap)(mapLookup.get( (String)(drawTable.getLast()) )) ).distance ) {
      drawTable.addLast(mapList[i]);
    } else if ( wLoopDistance > ( (CMap)(mapLookup.get( (String)(drawTable.getLast()) )) ).distance ) {
      if ( wLoopDistance >= ( (CMap)(mapLookup.get( (String)(drawTable.getFirst()) )) ).distance ) {
        drawTable.addFirst(mapList[i]);
      } else {
           while (!inserted) {
             if (wLoopDistance > ( (CMap)(mapLookup.get( (String)(drawTable.get(countLL)) )) ).distance ) {
               drawTable.add(countLL, mapList[i]);
               inserted = true;
             } else {
               countLL++;
             }
           }
      }
    }
    
    engine.popMatrix();//2
  }

  engine.popMatrix();//1

  engine.endDraw();
  


 
 
  
 
  //PART2: ITERATE THROUGH THE DRAW TABLE
  toolTip.setVisible(false);
  for (int i = 0; i < mapList.length; i++) {
    
    stroke(mapColour);
    strokeWeight(4);
      mapA = (String)(drawTable.get(i));
      if (( (CMap)(mapLookup.get(mapA)) ).isVisible) {
      x1 = ( (CMap)(mapLookup.get(mapA)) ).topX;
      y1 = ( (CMap)(mapLookup.get( mapA )) ).topY;
      x2 = ( (CMap)(mapLookup.get( mapA )) ).botX;
      y2 = ( (CMap)(mapLookup.get( mapA )) ).botY;
      thisDist = ( (CMap)(mapLookup.get(mapA)) ).distance;
      thisFeatureScale = featureScaleHandler(FEATURE_SCALE_BASE/thisDist);
      line(x1, y1, x2, y2);
      int currentTrackOffset = 0;
      
      //MAP TITLES
      noStroke();
      fill(mapColour);
      textFont(font12);
      textAlign(CENTER);
      if (!( (CMap)(mapLookup.get(mapA)) ).isReversed) {
        text(( (CMap)(mapLookup.get(mapA)) ).mapName,x1,y1-20);
      } else {
        text(( (CMap)(mapLookup.get(mapA)) ).mapName,x2,y2-20);
      }
      textFont(font10);
      textAlign(LEFT);
      //iterate through types for the given map
      for (int j = 0; j < typeList.length; j++) {
        
        //draw this feature type on the map if they exist
        if (singularTyped.get(mapA+":"+typeList[j]) != null) { //check singulars exist
          
          //iterate through features attached to this type
          for (int k = 0; k < ((String[])(singularTyped.get(mapA+":"+typeList[j]))).length; k++) {
            String thisFID = ((String[])(singularTyped.get(mapA+":"+typeList[j])))[k];
            float startOffset = ( (Feature)(featureLookup.get(thisFID)) ).startOffset;
            pushMatrix(); //1
              translate(x1, y1);
              pushMatrix(); //2
                translate( (x2-x1)*startOffset , (y2-y1)*startOffset );
                ((Feature)(featureLookup.get(thisFID)) ).x = screenX(0,0);
                ((Feature)(featureLookup.get(thisFID)) ).y = screenY(0,0);
                  
              popMatrix(); //2
            popMatrix();//1
            
            strokeWeight(2);
            stroke(typeColour[j%8]);
            
            //IF FEATURE IS VISIBLE, DRAW THE FEATURE
            if (((Feature)(featureLookup.get(thisFID))).visible) {
              if (((Feature)(featureLookup.get(thisFID))).hasCorrespondence) {
                stroke(correspondenceColour);
              }
              if (mouseX >= ((Feature)(featureLookup.get(thisFID))).x-thisFeatureScale/2 && mouseX <= ((Feature)(featureLookup.get(thisFID))).x+thisFeatureScale/2 && mouseY <= ((Feature)(featureLookup.get(thisFID))).y+3 && mouseY >= ((Feature)(featureLookup.get(thisFID))).y) {
                focusedFeatures.add(thisFID);
                stroke(highlightColour);
              }
              line(((Feature)(featureLookup.get(thisFID))).x+thisFeatureScale/2,((Feature)(featureLookup.get(thisFID))).y,((Feature)(featureLookup.get(thisFID))).x-thisFeatureScale/2,((Feature)(featureLookup.get(thisFID))).y);
              }
         }
       }
       
       if (rangedTyped.get(mapA+":"+typeList[j]) != null) {
         for (int k = 0; k < ((String[])(rangedTyped.get(mapA+":"+typeList[j]))).length; k++) {
           String thisFID = ((String[])(rangedTyped.get(mapA+":"+typeList[j])))[k];
           float startOffset = ( (Feature)(featureLookup.get(thisFID)) ).startOffset;
           float stopOffset = ( (Feature)(featureLookup.get(thisFID)) ).stopOffset;
           pushMatrix();//1
             translate(x1+10+(3*currentTrackOffset),y1);
             pushMatrix();//2
               translate( (x2-x1)*startOffset , (y2-y1)*startOffset );
               ((Feature)(featureLookup.get(thisFID)) ).x = screenX(0,0)+thisFeatureScale/3.0*((Feature)(featureLookup.get(thisFID)) ).tier;
               ((Feature)(featureLookup.get(thisFID)) ).y = screenY(0,0);
               pushMatrix();//3
                 translate( (x2-x1)*stopOffset , (y2-y1)*stopOffset );
                 ((Feature)(featureLookup.get(thisFID)) ).endX = screenX(0,0)+thisFeatureScale/3.0*((Feature)(featureLookup.get(thisFID)) ).tier;
                 ((Feature)(featureLookup.get(thisFID)) ).endY = screenY(0,0);
               popMatrix();//3
             popMatrix();//2
           popMatrix();//1
           
           strokeWeight(2);
           stroke(typeColour[j%8]);  
           if (((Feature)(featureLookup.get(thisFID))).visible) {
             if (((Feature)(featureLookup.get(thisFID))).hasCorrespondence) {
                stroke(correspondenceColour);
              }
              float fx1 = ( (Feature)(featureLookup.get(thisFID)) ).x;
              float fy1 = ( (Feature)(featureLookup.get(thisFID)) ).y;
              float fx2 = ( (Feature)(featureLookup.get(thisFID)) ).endX;
              float fy2 = ( (Feature)(featureLookup.get(thisFID)) ).endY;
              
              
              //TODO: THIS (y range) WILL NEED TO BE SWAPPED AROUND FOR REVERSED MAPS
              
              if ((!( (CMap)(mapLookup.get(mapA)) ).isReversed && 
                  mouseY > ( (Feature)(featureLookup.get(thisFID)) ).y &&
                  mouseY < ( (Feature)(featureLookup.get(thisFID)) ).endY &&
                  mouseX > ((mouseY-fy1)/((fy2-fy1)/(fx2-fx1)))+fx1-1 &&
                  mouseX < ((mouseY-fy1)/((fy2-fy1)/(fx2-fx1)))+fx1+3) || 
                  (( (CMap)(mapLookup.get(mapA)) ).isReversed && 
                  mouseY < ( (Feature)(featureLookup.get(thisFID)) ).y &&
                  mouseY > ( (Feature)(featureLookup.get(thisFID)) ).endY &&
                  mouseX > ((mouseY-fy1)/((fy2-fy1)/(fx2-fx1)))+fx1-1 &&
                  mouseX < ((mouseY-fy1)/((fy2-fy1)/(fx2-fx1)))+fx1+3))
              {
                noStroke();
                fill(#333333);
                
                focusedFeatures.add(thisFID);
                
                stroke(highlightColour);
              }
             line(((Feature)(featureLookup.get(thisFID))).x,((Feature)(featureLookup.get(thisFID))).y,((Feature)(featureLookup.get(thisFID))).endX,((Feature)(featureLookup.get(thisFID))).endY);
             
           }
         }
         currentTrackOffset += ((Track)(trackLookup.get(mapA+":"+typeList[j]))).depth;
       }
       
     }
     if (mapList.length > 0) {
       fill(255,102,0);
       strokeWeight(1);
       stroke(correspondenceLineColour);
       for (int j = 0; j < i; j++) {
         mapB = (String)(drawTable.get(j));
         String [] classList;
         if ( correspondence.getCorrespondenceList(correspondence.getClass(mapA,mapB)).length > 0 && 
         ( (CMap)(mapLookup.get(mapA)) ).isVisible && 
         ( (CMap)(mapLookup.get(mapB)) ).isVisible ) {
           classList = correspondence.getCorrespondenceList(correspondence.getClass(mapA,mapB));
           for (int k = 0; k < classList.length; k+=2) {
             featA = classList[k];
             featB = classList[k+1];
             if (( (Feature)(featureLookup.get(featA)) ).visible && ( (Feature)(featureLookup.get(featB)) ).visible) {
               line( ( (Feature)(featureLookup.get(featA)) ).x, ( (Feature)(featureLookup.get(featA)) ).y,
                      ( (Feature)(featureLookup.get(featB)) ).x, ( (Feature)(featureLookup.get(featB)) ).y);
             }
            }
          }
        }
     }
  }
  }
 int countTest = 0;
 
 
 //PART 3: TEXT LABELS
 for (int i = 0; i < mapList.length; i++) {
   
   mapA = (String)(drawTable.get(i));
   if (( (CMap)(mapLookup.get(mapA)) ).isVisible) {
   
   thisDist = ( (CMap)(mapLookup.get(mapA)) ).distance;
   thisFeatureScale = featureScaleHandler(FEATURE_SCALE_BASE/thisDist);
   noStroke();     
     if (thisFeatureScale >= 6) {textFont(font8);}
     if (thisFeatureScale > 10) {textFont(font10);}
     if (thisFeatureScale > 14) {textFont(font12);}
   for (int j = 0; j < typeList.length; j++) {
        
        //draw this feature type on the map if they exist
        if (singularTyped.get(mapA+":"+typeList[j]) != null) { //check singulars exist
          textAlign(RIGHT);
          fill(defaultColour);
          //iterate through features attached to this type
          for (int k = 0; k < ((String[])(singularTyped.get(mapA+":"+typeList[j]))).length; k++) {
            String thisFID = ((String[])(singularTyped.get(mapA+":"+typeList[j])))[k];
            
            
            //IF FEATURE IS VISIBLE, DRAW THE FEATURE
            if (((Feature)(featureLookup.get(thisFID))).visible) {
              
              if (((Feature)(featureLookup.get(thisFID))).hasCorrespondence) {
                fill(correspondenceColour);
              } 
              
              if (mouseX >= ((Feature)(featureLookup.get(thisFID))).x-thisFeatureScale/2 && mouseX <= ((Feature)(featureLookup.get(thisFID))).x+thisFeatureScale/2 && mouseY <= ((Feature)(featureLookup.get(thisFID))).y+3 && mouseY >= ((Feature)(featureLookup.get(thisFID))).y) {
                fill(highlightColour);

              }
              text(((Feature)(featureLookup.get(thisFID)) ).featureName, ((Feature)(featureLookup.get(thisFID))).x-5 ,((Feature)(featureLookup.get(thisFID))).y);
              fill(defaultColour);
            }
         }
       }
       
       
       
     }
 }
 }
 strokeWeight(1);
 fill(backgroundControl);
 stroke(panelColour);
 rectMode(CORNER);
 showTooltip();
 
             if (toolTip.isVisible()) rect(mouseX+5,mouseY,110,50);
}
void arrayBoundsHandler() {
  if (rotation >= ROTATION_RANGE) {rotation = 0;}
  if (rotation < 0) {rotation = ROTATION_RANGE-1;}
  if (incline >= INCLINE_RANGE) {incline = INCLINE_RANGE-1;}
  if (incline <= -INCLINE_RANGE) {incline = (-INCLINE_RANGE)+1;}
}

float featureScaleHandler(float inNum) {
  if (inNum < 6) {
    return 6;
  } else if (inNum > 18) {
    return 18;
  } else {
    return inNum;
  }
}


void drawCurrentRepositoryTab () {
      fill(activeControl);
      textAlign(RIGHT);
      textFont(currentRepositoryFont);
      text(repositoryList[currentRepository][1],985,43);
}

void drawCurrentRepositoryEngine () {
      fill(activeControl);
      textAlign(LEFT);
      textFont(currentRepositoryFont);
      for (int i = 0; i < currentRepositoryEngine.length; i++) {
      text(currentRepositoryEngine[i],15,30+15*i);
      }
}

void calculateCurrentRepositoryEngine () {
    textAlign(LEFT);
    textFont(currentRepositoryFont);
    int tier = 0;
    currentRepositoryEngine = new String[0];
    String [] cutUp = split(repositoryList[currentRepository][1],' ');
    String currentLine = "";
    for (int i = 0; i < cutUp.length; i++) {
      currentLine += cutUp[i]+" ";
      if (textWidth(currentLine) > 170*(tier+1)) {
        currentLine = currentLine.substring(0,currentLine.length()-(cutUp[i].length()+1));
        currentRepositoryEngine = append(currentRepositoryEngine,currentLine);
        currentLine = cutUp[i]+" ";
        tier++;
      }
    }
    currentRepositoryEngine = append(currentRepositoryEngine,currentLine);
}

void loadingImage (int x, int y) {
  image(loading[loadingCount],x,y);
  loadingCount++;
  if (loadingCount > 30) loadingCount = 0;
}

void loadingImage (int x, int y, int m) {
  image(loading[loadingCount],x,y,m,m);
  loadingCount++;
  if (loadingCount > 30) loadingCount = 0;
}

void drawTabWindow () {
        image(tabWindow,0,0);
      image(tabNav,0,0);
      image(version,26,543);
      drawCurrentRepositoryTab();
}
  
void drawEngineWindow() {
          drawCurrentRepositoryEngine();
    image(engineWindow,0,0);
    image(version,910,560);
}

void showTooltip() {
  
     if (focusedFeatures.size() > 0 && !mousePressed) {
     noStroke();
     
     textAlign(LEFT);
     ellipseMode(CENTER);
     
     float textLength = 0;
     
     //get the length required for the box
     for (int i = 0; i < focusedFeatures.size(); i++) {
       String thisFeature = (String)(focusedFeatures.get(i));
       String thisFeatureName = ( (Feature)(featureLookup.get(thisFeature)) ).featureName;
       String thisFeatureUnit = "";
       String thisFeatureType = ( (Feature)(featureLookup.get(thisFeature)) ).featureType;
       if (( (Feature)(featureLookup.get(thisFeature)) ).hasRange) {
         thisFeatureUnit = ( (Feature)(featureLookup.get(thisFeature)) ).start+( (Feature)(featureLookup.get(thisFeature)) ).featureUnit+" - "+
                           ( (Feature)(featureLookup.get(thisFeature)) ).stop+( (Feature)(featureLookup.get(thisFeature)) ).featureUnit;
       } else {
         thisFeatureUnit = ( (Feature)(featureLookup.get(thisFeature)) ).start+( (Feature)(featureLookup.get(thisFeature)) ).featureUnit;
       }
       textFont(tooltipFontBold);
       if (textWidth(thisFeatureName) > textLength) {
         textLength = textWidth(thisFeatureName);
       }
       textFont(tooltipFont);
       if (textWidth(thisFeatureUnit) > textLength) {
         textLength = textWidth(thisFeatureUnit);
       }
       if (textWidth(thisFeatureType) > textLength) {
         textLength = textWidth(thisFeatureType);
       }
     }
     
     for (int i = 0; i < focusedFeatures.size(); i++) {
       String thisFeature = (String)(focusedFeatures.get(i));
       String thisFeatureName = ( (Feature)(featureLookup.get(thisFeature)) ).featureName;
       String thisFeatureUnit = "";
       String thisFeatureType = ( (Feature)(featureLookup.get(thisFeature)) ).featureType;
       if (( (Feature)(featureLookup.get(thisFeature)) ).hasRange) {
         thisFeatureUnit = ( (Feature)(featureLookup.get(thisFeature)) ).start+( (Feature)(featureLookup.get(thisFeature)) ).featureUnit+" - "+
                           ( (Feature)(featureLookup.get(thisFeature)) ).stop+( (Feature)(featureLookup.get(thisFeature)) ).featureUnit;
       } else {
         thisFeatureUnit = ( (Feature)(featureLookup.get(thisFeature)) ).start+( (Feature)(featureLookup.get(thisFeature)) ).featureUnit;
       }
       
       boolean colorChosen = false;
       int colorIter = 0;
       while (!colorChosen) {
         if (typeList[colorIter].equals(thisFeatureType)) {
           colorChosen = true;
         } else {
           colorIter++;
         }
       }
       
       pushMatrix();
         if (mouseX+30+textLength > 1000) {
           translate(mouseX-textLength-30,mouseY+55*i);
         } else {
           translate(mouseX+10,mouseY+55*i);
         }
         
         fill(tooltipBackground);
         rect(10,0,textLength,50);
         rect(0,10,10,30);
         rect(10+textLength,10,10,30);
         arc(10,10,20,20,PI,TWO_PI-PI/2);
         arc(10+textLength,10,20,20,TWO_PI-PI/2,0);
         arc(10+textLength,40,20,20,0,PI/2);
         arc(10,40,20,20,PI/2,PI);
         
         textFont(tooltipFontBold);
         fill(labelText);
         if (( (Feature)(featureLookup.get(thisFeature)) ).hasCorrespondence) fill(correspondenceColour);
         text(thisFeatureName,10,15);
         stroke(labelText);
         if (( (Feature)(featureLookup.get(thisFeature)) ).hasCorrespondence) stroke(correspondenceColour);
         strokeWeight(1);
         line(10,17,10+textWidth(thisFeatureName),17);
         noStroke();
         fill(labelText);
         textFont(tooltipFont);
         text(thisFeatureUnit,14,30);
         fill(typeColour[colorIter]);
         text(thisFeatureType,14,40);
         
       popMatrix();
       
     }

     }
}

void processConfigFile() {
    try {
      config = new P5Properties();
      
      config.load(openStream("config.properties"));
      
      boolean enabled = config.getBooleanProperty("net.proxy.enable", false);
      String host = config.getStringProperty("net.proxy.host", "");
      String port = config.getStringProperty("net.proxy.port", "8080");
      repositoryURL = config.getStringProperty("repos.master.url",repositoryURL);
      
      if (enabled) {
        System.setProperty("http.proxyHost",host);
        System.setProperty("http.proxyPort",port);
      }
      
    } catch (Exception e) {
      println("Error reading config file, defaults used");
    }
}


class P5Properties extends Properties {
 
  boolean getBooleanProperty(String id, boolean defState) {
    return boolean(getProperty(id,""+defState));
  }
 
  int getIntProperty(String id, int defVal) {
    return int(getProperty(id,""+defVal)); 
  }
 
  float getFloatProperty(String id, float defVal) {
    return float(getProperty(id,""+defVal)); 
  }  
  
  String getStringProperty(String id, String defVal) {
    return getProperty(id,defVal);
  }
}
