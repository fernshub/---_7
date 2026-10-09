import 'dart:async';
import 'package:flutter/material.dart';

class PrayerHeaderScreen extends StatefulWidget {
  const PrayerHeaderScreen({Key? key}) : super(key: key);

  @override
  State<PrayerHeaderScreen> createState() => _PrayerHeaderScreenState();
}

class _PrayerHeaderScreenState extends State<PrayerHeaderScreen> {
  // عداد تنازلي تجريبي (بالثواني) لنفترض أن الوقت المتبقي هو 29 دقيقة و 19 ثانية
  late Timer _timer;
  int _secondsRemaining = 1759; 

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  // دالة تشغيل العد التنازلي التلقائي
  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _secondsRemaining = 0;
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  // تنسيق الثواني إلى صيغة HH:MM:SS
  String _formatTime(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int secs = seconds % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    // قائمة الصلوات اليومية لعرضها في الشريط الأفقي
    final List<Map<String, String>> prayers = [
      {'name': 'الفجر', 'time': '04:40 AM'},
      {'name': 'الشروق', 'time': '06:02 AM'},
      {'name': 'الظهر', 'time': '11:55 AM'},
      {'name': 'العصر', 'time': '03:10 PM'},
      {'name': 'المغرب', 'time': '05:39 PM'},
      {'name': 'العشاء', 'time': '06:54 PM'},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF121212), // خلفية داكنة عصرية
      body: Directionality(
        textDirection: TextDirection.rtl, // دعم اللغة العربية من اليمين لليسار
        child: SingleChildScrollView(
          child: Column(
            children: [
              // 1. رأس التطبيق مع الخلفية المتدرجة والعداد التنازلي
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 45, bottom: 25, left: 16, right: 16),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFE65C00), Color(0xFFF9D423)], // تدرج وقت الغروب الذهبي
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(35),
                    bottomRight: Radius.circular(35),
                  ),
                ),
                child: Column(
                  children: [
                    // شريط العلوي (الإشعارات، الموقع، القائمة)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.notifications_active, color: Colors.white),
                          onPressed: () {},
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.25),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.location_on, color: Colors.amberAccent, size: 16),
                              SizedBox(width: 5),
                              Text(
                                'بغداد، العراق',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.grid_view_rounded, color: Colors.white),
                          onPressed: () {},
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),
                    
                    // نص إعلان الصلاة القادمة
                    const Text(
                      'المغرب بعد',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // مؤقت العد التنازلي
                    Text(
                      _formatTime(_secondsRemaining),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 15),
                  ],
                ),
              ),
              
              const SizedBox(height: 20),

              // 2. شريط أوقات الصلاة الأفقي المتحرك
              SizedBox(
                height: 105,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: prayers.length,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemBuilder: (context, index) {
                    final prayer = prayers[index];
                    bool isCurrentPrayer = prayer['name'] == 'المغرب'; // تمييز الصلاة القادمة
                    
                    return Container(
                      width: 85,
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isCurrentPrayer 
                            ? const Color(0xFFE65C00).withOpacity(0.25) 
                            : Colors.white.withOpacity(0.06),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: isCurrentPrayer ? const Color(0xFFE65C00) : Colors.white12,
                          width: isCurrentPrayer ? 2 : 1,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            prayer['name']!,
                            style: TextStyle(
                              color: isCurrentPrayer ? Colors.orangeAccent : Colors.white70,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Icon(Icons.access_time_filled, color: Colors.amber, size: 18),
                          const SizedBox(height: 6),
                          Text(
                            prayer['time']!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
