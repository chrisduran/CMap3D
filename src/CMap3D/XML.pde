void xmlEvent(proxml.XMLElement element) {
  cmapdata = element;
  if (cmapdata.getName().equals("repository_listing")) {
    processRepositoryList();
  } else if (cmapdata.getName().equals("cmap3d")) {
    processXML();
  } else if (cmapdata.getName().equals("species_listing")) {
    processSpeciesList();
  } else if (cmapdata.getName().equals("map_set_listing")) {
    processMapSetList();
  } else if (cmapdata.getName().equals("map_listing")) {
    processMapList();
  }
}

void processMapList() {
  mapsListAcc = new String[cmapdata.countChildren()];
  for (int i = 0; i < cmapdata.countChildren(); i++) {
    mapsListAcc[i] = cmapdata.getChild(i).getAttribute("acc");
    //println(cmapdata.getChild(i).getAttribute("acc"));
  }
  addMapStage = 18;
}

void processMapSetList() {
  mapSetListAcc = new String[cmapdata.countChildren()];
  for (int i = 0; i < cmapdata.countChildren(); i++) {
    mapSetListAcc[i] = cmapdata.getChild(i).getChild(0).getText();
    //println(i);
  }
  addMapStage = 13;
  
}

void processSpeciesList() {
  speciesListAcc = new String[cmapdata.countChildren()];
  speciesListName = new String[cmapdata.countChildren()];
  for (int i = 0; i < cmapdata.countChildren(); i++) {

    speciesListName[i] = cmapdata.getChild(i).getChild(0).getChild(0).getText();
    speciesListAcc[i] = cmapdata.getChild(i).getAttribute("acc");
    
  }
  addMapStage = 7;
}

void processRepositoryList() {
  
  repositoryList = new String[cmapdata.countChildren()][0];
  for (int i = 0; i < cmapdata.countChildren(); i++) {
    controlP5.Button b = repositoryListDisplay.addItem(cmapdata.getChild(i).getAttribute("shortname").replace('~',' '),i);
    b.addListener(repositoryListener);
    repositoryList[i] = append(repositoryList[i], cmapdata.getChild(i).getAttribute("shortname").replace('~',' '));
    repositoryList[i] = append(repositoryList[i], cmapdata.getChild(i).getChild(0).getChild(0).getText());
    repositoryList[i] = append(repositoryList[i], cmapdata.getChild(i).getChild(1).getChild(0).getText());
    repositoryList[i] = append(repositoryList[i], cmapdata.getChild(i).getChild(2).getChild(0).getText());
    repositoryList[i] = append(repositoryList[i], cmapdata.getChild(i).getChild(3).getChild(0).getText());
    repositoryList[i] = append(repositoryList[i], cmapdata.getChild(i).getChild(4).getChild(0).getText());
    if (i == 0) {
      b.setColorBackground(activeControl);
      b.setColorLabel(0);
      changeRepository();
    }
    
   }
   
   repositoryListDisplay.setVisible(true);
   repositoryDetails.setVisible(true);
   drawStage = 2;
   
}

void processXML() {
 
  //DEBUG:
  //cmapdata.printElementTree();
  
  //POPULATE the typeList & mapList arrays
  for (int i = 0; i < cmapdata.countChildren(); i++) {
    currentElement = cmapdata.getChild(i);
    
    //THE TYPELIST ARRAY
    if (currentElement.getName().equals("types")) {
      typeList = new String[currentElement.countChildren()];
      for (int j = 0; j < currentElement.countChildren(); j++) {
        typeList[j] = currentElement.getChild(j).getAttribute("value");
      }
    }
    
    //THE MAPLIST ARRAY, AND THE MAP LOOKUP TABLE
    if (currentElement.getName().equals("maps")) {
      for (int j = 0; j < currentElement.countChildren(); j++) {
        XMLmap = currentElement.getChild(j);
        currentXMLmap = mapList[j] = XMLmap.getAttribute("map_acc");
        mapLookup.put(mapList[j],new CMap(XMLmap.getChild(0).getChild(0).getChild(0).getText(),
                                          XMLmap.getFloatAttribute("map_start"),
                                          XMLmap.getFloatAttribute("map_stop"),
                                          XMLmap.getAttribute("map_units")));
        
        //PROCESS RANGED AND SINGULAR FEATURE TYPES                                 
        for (int k = 0; k < XMLmap.countChildren(); k++) {
          
          //RANGED FEATURES
          if (XMLmap.getChild(k).getName().equals("ranged_features")) {
            for (int l = 0; l < XMLmap.getChild(k).countChildren(); l++) {
              XMLtype = XMLmap.getChild(k).getChild(l);
              currentXMLtype = XMLtype.getAttribute("type");
              //ADD THE RANGED FEATURES TO THE RELEVANT LOOKUP TABLES
              String [] featureBuilder = new String [XMLtype.countChildren()];
              float [] tracks = {XMLmap.getFloatAttribute("map_start")};
              int tier = 0;
              for (int m = 0; m < XMLtype.countChildren(); m++) {
                XMLfeature = XMLtype.getChild(m);
                featureBuilder[m] = XMLfeature.getAttribute("feature_acc");
                
                //start tracks population
                int n = 0;
                boolean trackFilled = false;
                while (!trackFilled) {
                  if (XMLfeature.getFloatAttribute("feature_start") >= tracks[n]) {
                    tier = n;
                    tracks[n] = XMLfeature.getFloatAttribute("feature_stop");
                    trackFilled = true;
                  } else if (XMLfeature.getFloatAttribute("feature_start") < tracks[n] && n == tracks.length-1) {
                    tier = n+1;
                    tracks = append(tracks,XMLfeature.getFloatAttribute("feature_stop"));
                    trackFilled = true;
                  }
                  n++;
                }
                //end tracks population
                
                featureLookup.put(XMLfeature.getAttribute("feature_acc"),new Feature(XMLfeature.getAttribute("feature_name").replace('~',' '),
                                                                                    XMLfeature.getFloatAttribute("feature_start"),
                                                                                    XMLfeature.getFloatAttribute("feature_stop"),
                                                                                    XMLmap.getFloatAttribute("map_start"),
                                                                                    XMLmap.getFloatAttribute("map_stop"),
                                                                                    XMLmap.getAttribute("map_units"), currentXMLtype, tier));
                
                
                
              }
              rangedTyped.put(currentXMLmap+":"+currentXMLtype,featureBuilder);
              trackLookup.put(currentXMLmap+":"+currentXMLtype,new Track(tracks.length));
            }
          }
          
          //SINGULAR FEATURES
          if (XMLmap.getChild(k).getName().equals("singular_features")) {
            for (int l = 0; l < XMLmap.getChild(k).countChildren(); l++) {
              XMLtype = XMLmap.getChild(k).getChild(l);
              currentXMLtype = XMLtype.getAttribute("type");
              //ADD THE RANGED FEATURES TO THE RELEVANT LOOKUP TABLES
              String [] featureBuilder = new String [XMLtype.countChildren()];
              for (int m = 0; m < XMLtype.countChildren(); m++) {
                XMLfeature = XMLtype.getChild(m);
                featureBuilder[m] = XMLfeature.getAttribute("feature_acc");
                featureLookup.put(XMLfeature.getAttribute("feature_acc"),new Feature(XMLfeature.getAttribute("feature_name").replace('~',' '),
                                                                                    XMLfeature.getFloatAttribute("feature_start"),
                                                                                    XMLfeature.getFloatAttribute("feature_stop"),
                                                                                    XMLmap.getFloatAttribute("map_start"),
                                                                                    XMLmap.getFloatAttribute("map_stop"),
                                                                                    XMLmap.getAttribute("map_units"), currentXMLtype));
              }
              singularTyped.put(currentXMLmap+":"+currentXMLtype,featureBuilder);
            }
          }
        }
      }
      
    }
    

  }
  //CORRESPONDENCE
  for (int i = 0; i < cmapdata.countChildren(); i++) {
    currentElement = cmapdata.getChild(i);
    if (currentElement.getName().equals("correspondences")) {
      globalHasCorres = true;
      correspondence = new CorrespondenceClass(mapList);
      for (int j = 0; j < currentElement.countChildren(); j++) {
        XMLcorres = currentElement.getChild(j);
        correspondence.addCorrespondence(XMLcorres.getAttribute("map_acc1"),XMLcorres.getAttribute("map_acc2"),
                                         XMLcorres.getAttribute("feature_acc1"),XMLcorres.getAttribute("feature_acc2"));
        ((Feature)(featureLookup.get(XMLcorres.getAttribute("feature_acc1")))).hasCorrespondence = true;
        ((Feature)(featureLookup.get(XMLcorres.getAttribute("feature_acc2")))).hasCorrespondence = true;
      }
    }
  }
  
  mapPositions = new MapArranger(mapList.length, false);
  
  for (int i = 0; i < mapList.length; i++) {
    ( (CMap)(mapLookup.get(mapList[i])) ).arrangeX = mapPositions.x[i];
    ( (CMap)(mapLookup.get(mapList[i])) ).arrangeZ = mapPositions.z[i];
  }
  
  
        
  drawStage = 22; //lets the program know that the XML has been completed
}
