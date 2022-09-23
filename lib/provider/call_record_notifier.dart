

import 'dart:core';


import 'package:flutter/cupertino.dart';

class CallRecordingNotifer with ChangeNotifier{

  List<String> _songsList = [];
   List<String> get songsList => _songsList;
   setSongsList(String songPath){
     _songsList.add(songPath);
     notifyListeners();
   }


   bool _isPlaying = false;
   bool get isPlaying => _isPlaying;
   setIsPlaying(bool value){
     _isPlaying = value;
     notifyListeners();
   }

   Duration _duration = Duration.zero;
   Duration get duration => _duration;
   setDuration(Duration value){
     _duration = value;
     notifyListeners();
   }
   Duration _position = Duration.zero;
  Duration get position => _position;
  setPosition(Duration value){
    _duration = value;
    notifyListeners();
  }
  int? _currentSongIndex;
  int? get currentSongIndex => _currentSongIndex;
   setCurrentSongIndex(int value){
    _currentSongIndex = value;
    notifyListeners();
  }
}