import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/colors.dart';
import '../services/firebase_video_service.dart';

// 🔥 EXTRAORDINARY VIDEO PLAYER - VINU BHAISAHAB KA MASTERPIECE 🔥
class ExtraordinaryVideoPlayer extends StatefulWidget {
  const ExtraordinaryVideoPlayer({super.key});

  @override
  State<ExtraordinaryVideoPlayer> createState() => _ExtraordinaryVideoPlayerState();
}

class _ExtraordinaryVideoPlayerState extends State<ExtraordinaryVideoPlayer>
    with TickerProviderStateMixin {
  
  // 🎬 VIDEO CONTROLLERS 🎬
  List<VideoPlayerController> _videoControllers = [];
  List<ChewieController> _chewieControllers = [];
  PageController _pageController = PageController();
  
  // 🎯 STATE VARIABLES 🎯
  List<String> _videoUrls = [];
  int _currentVideoIndex = 0;
  bool _isLoading = true;
  bool _isMuted = false;
  bool _isPlaying = true;
  
  // 🌟 ANIMATION CONTROLLERS 🌟
  late AnimationController _glowAnimationController;
  late AnimationController _borderAnimationController;
  late Animation<double> _glowAnimation;
  late Animation<double> _borderAnimation;
  
  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadVideos();
  }
  
  // 🎨 INITIALIZE ANIMATIONS 🎨
  void _initializeAnimations() {
    _glowAnimationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    
    _borderAnimationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    
    _glowAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _glowAnimationController, curve: Curves.easeInOut),
    );
    
    _borderAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _borderAnimationController, curve: Curves.linear),
    );
    
    _glowAnimationController.repeat(reverse: true);
    _borderAnimationController.repeat();
  }
  
  // 📱 LOAD VIDEOS FROM FIREBASE 📱
  Future<void> _loadVideos() async {
    try {
      setState(() => _isLoading = true);
      
      final videos = await FirebaseVideoService.getVideosBatch(limit: 5);
      
      if (videos.isNotEmpty) {
        _videoUrls = videos;
        await _initializeVideoControllers();
      }
      
      setState(() => _isLoading = false);
    } catch (e) {
      print('❌ Error loading videos: $e');
      setState(() => _isLoading = false);
    }
  }
  
  // 🎮 INITIALIZE VIDEO CONTROLLERS 🎮
  Future<void> _initializeVideoControllers() async {
    // Dispose existing controllers
    _disposeControllers();
    
    _videoControllers = [];
    _chewieControllers = [];
    
    for (int i = 0; i < _videoUrls.length; i++) {
      try {
        final videoController = VideoPlayerController.networkUrl(
          Uri.parse(_videoUrls[i]),
        );
        
        await videoController.initialize();
        
        final chewieController = ChewieController(
          videoPlayerController: videoController,
          autoPlay: i == 0, // Only auto-play first video
          looping: true,
          showControls: false,
          aspectRatio: 16 / 9,
          allowFullScreen: false,
          allowMuting: false,
          showControlsOnInitialize: false,
        );
        
        _videoControllers.add(videoController);
        _chewieControllers.add(chewieController);
        
        // Log video view for analytics
        if (i == 0) {
          FirebaseVideoService.logVideoView(_videoUrls[i]);
        }
        
      } catch (e) {
        print('❌ Error initializing video ${i}: $e');
      }
    }
    
    if (mounted) setState(() {});
  }
  
  // 🗑️ DISPOSE CONTROLLERS 🗑️
  void _disposeControllers() {
    for (var controller in _chewieControllers) {
      controller.dispose();
    }
    for (var controller in _videoControllers) {
      controller.dispose();
    }
  }
  
  @override
  void dispose() {
    _disposeControllers();
    _pageController.dispose();
    _glowAnimationController.dispose();
    _borderAnimationController.dispose();
    super.dispose();
  }
  
  // 🎯 HANDLE VIDEO CHANGE 🎯
  void _onVideoChanged(int index) {
    if (index != _currentVideoIndex && index < _chewieControllers.length) {
      // Pause current video
      if (_currentVideoIndex < _chewieControllers.length) {
        _chewieControllers[_currentVideoIndex].pause();
      }
      
      // Play new video
      _chewieControllers[index].play();
      
      // Log interaction
      FirebaseVideoService.logVideoInteraction(_videoUrls[index], 'swipe');
      FirebaseVideoService.logVideoView(_videoUrls[index]);
      
      setState(() {
        _currentVideoIndex = index;
        _isPlaying = true;
      });
    }
  }
  
  // 🔇 TOGGLE MUTE 🔇
  void _toggleMute() {
    if (_currentVideoIndex < _chewieControllers.length) {
      final controller = _chewieControllers[_currentVideoIndex];
      final newVolume = _isMuted ? 1.0 : 0.0;
      controller.setVolume(newVolume);
      
      setState(() => _isMuted = !_isMuted);
      
      FirebaseVideoService.logVideoInteraction(
        _videoUrls[_currentVideoIndex], 
        _isMuted ? 'mute' : 'unmute'
      );
    }
  }
  
  // ⏯️ TOGGLE PLAY/PAUSE ⏯️
  void _togglePlayPause() {
    if (_currentVideoIndex < _chewieControllers.length) {
      final controller = _chewieControllers[_currentVideoIndex];
      
      if (_isPlaying) {
        controller.pause();
      } else {
        controller.play();
      }
      
      setState(() => _isPlaying = !_isPlaying);
      
      FirebaseVideoService.logVideoInteraction(
        _videoUrls[_currentVideoIndex], 
        _isPlaying ? 'play' : 'pause'
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return _buildLoadingWidget();
    }
    
    if (_videoUrls.isEmpty || _chewieControllers.isEmpty) {
      return _buildErrorWidget();
    }
    
    return _buildVideoPlayer();
  }
  
  // 🔄 LOADING WIDGET 🔄
  Widget _buildLoadingWidget() {
    return Container(
      height: 200,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            AppColors.gradientStart.withOpacity(0.1),
            AppColors.gradientMiddle.withOpacity(0.1),
            AppColors.gradientEnd.withOpacity(0.1),
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: AppColors.gradientStart,
              strokeWidth: 3,
            ),
            const SizedBox(height: 16),
            Text(
              'Loading Trending Videos...',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  // ❌ ERROR WIDGET ❌
  Widget _buildErrorWidget() {
    return Container(
      height: 200,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.grey[900],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              color: AppColors.gradientStart,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              'Unable to load videos',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _loadVideos,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.gradientStart,
              ),
              child: Text(
                'Retry',
                style: GoogleFonts.poppins(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🎬 MAIN VIDEO PLAYER 🎬
  Widget _buildVideoPlayer() {
    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (context, child) {
        return Container(
          height: 200,
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColors.gradientStart.withOpacity(_glowAnimation.value * 0.5),
                blurRadius: 20,
                spreadRadius: 2,
              ),
              BoxShadow(
                color: AppColors.gradientMiddle.withOpacity(_glowAnimation.value * 0.3),
                blurRadius: 30,
                spreadRadius: 4,
              ),
            ],
          ),
          child: Stack(
            children: [
              // 🎥 VIDEO CONTENT 🎥
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: _onVideoChanged,
                  itemCount: _chewieControllers.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: _togglePlayPause,
                      child: Chewie(controller: _chewieControllers[index]),
                    );
                  },
                ),
              ),

              // 🌈 ANIMATED BORDER 🌈
              AnimatedBuilder(
                animation: _borderAnimation,
                builder: (context, child) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        width: 2,
                        color: Color.lerp(
                          AppColors.gradientStart,
                          AppColors.gradientEnd,
                          _borderAnimation.value,
                        )!.withOpacity(0.8),
                      ),
                    ),
                  );
                },
              ),

              // 🎮 CONTROL OVERLAY 🎮
              _buildControlOverlay(),

              // 📊 VIDEO INDICATOR 📊
              _buildVideoIndicator(),
            ],
          ),
        );
      },
    );
  }

  // 🎮 CONTROL OVERLAY 🎮
  Widget _buildControlOverlay() {
    return Positioned(
      top: 12,
      right: 12,
      child: Column(
        children: [
          // 🔇 MUTE BUTTON 🔇
          GestureDetector(
            onTap: _toggleMute,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.gradientStart.withOpacity(0.5),
                  width: 1,
                ),
              ),
              child: Icon(
                _isMuted ? Icons.volume_off : Icons.volume_up,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),

          const SizedBox(height: 8),

          // ⏯️ PLAY/PAUSE BUTTON ⏯️
          GestureDetector(
            onTap: _togglePlayPause,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.gradientStart.withOpacity(0.5),
                  width: 1,
                ),
              ),
              child: Icon(
                _isPlaying ? Icons.pause : Icons.play_arrow,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 📊 VIDEO INDICATOR 📊
  Widget _buildVideoIndicator() {
    return Positioned(
      bottom: 12,
      left: 12,
      right: 12,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(_videoUrls.length, (index) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(horizontal: 3),
            height: 4,
            width: index == _currentVideoIndex ? 24 : 8,
            decoration: BoxDecoration(
              color: index == _currentVideoIndex
                  ? AppColors.gradientStart
                  : Colors.white.withOpacity(0.4),
              borderRadius: BorderRadius.circular(2),
            ),
          );
        }),
      ),
    );
  }
}
