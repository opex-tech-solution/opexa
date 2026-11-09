import 'package:flutter/material.dart';

class WhyThisBlockScreen extends StatelessWidget {
  const WhyThisBlockScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top App Bar Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: isDark ? Colors.white70 : Colors.black87),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Why this block?",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // What We Saw Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.visibility_outlined, size: 18, color: Color(0xFF1B4988)),
                              const SizedBox(width: 8),
                              Text(
                                "What we saw",
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: isDark ? Colors.white : Colors.black87),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          _bulletItem("On 2x + 9 = 3 you answered x = 3 (fairly sure).", isDark),
                          _bulletItem("You worked out 3 − 9 as 6.", isDark),
                          _bulletItem("−3 − 5: you answered −2.", isDark),
                          const SizedBox(height: 8),
                          GestureDetector(
                            onTap: () {},
                            child: const Text(
                              "› Show all 4",
                              style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, color: Color(0xFF6B9BFA)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Our Best Guess Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "OUR BEST GUESS",
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 0.8),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Taking away into negative numbers",
                            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE8F1FF),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.signal_cellular_alt, size: 14, color: Color(0xFF1B4988)),
                                SizedBox(width: 6),
                                Text("How sure we are: High", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1B4988))),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Several separate questions pointed the same way.",
                            style: TextStyle(fontSize: 13, color: isDark ? Colors.white70 : Colors.black54, height: 1.35),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // What Else It Could Be Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "WHAT ELSE IT COULD BE",
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 0.8),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Doing the two steps in the right order",
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // What Would Change Our View Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "WHAT WOULD CHANGE OUR VIEW",
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 0.8),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "If you got fresh questions on add & subtract integers right on your own, we'd think again.",
                            style: TextStyle(fontSize: 13.5, color: isDark ? Colors.white70 : Colors.black54, height: 1.4),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bulletItem(String text, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("› ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.grey)),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 13.5, color: isDark ? Colors.white70 : Colors.black87, height: 1.35),
            ),
          ),
        ],
      ),
    );
  }
}
