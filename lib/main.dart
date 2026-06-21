import 'package:flutter/material.dart';
import 'peg_game.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Triangle Peg Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List<JumpRec> _moveHistory = [];
  final ScrollController _moveScrollController = ScrollController();
  final ScrollController _appHistoryScrollController = ScrollController();

  @override
  void dispose() {
    _moveScrollController.dispose();
    _appHistoryScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Triangle Peg Game'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 900) {
            return Row(
              children: [
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: PegGame(
                        onHistoryChanged: (history) {
                          setState(() {
                            _moveHistory = history;
                          });
                          // Scroll to bottom on next frame
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            if (_moveScrollController.hasClients) {
                              _moveScrollController.animateTo(
                                _moveScrollController.position.maxScrollExtent,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeOut,
                              );
                            }
                          });
                        },
                      ),
                    ),
                  ),
                ),
                _buildSidebar(context),
              ],
            );
          } else {
            return Column(
              children: [
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: PegGame(
                        onHistoryChanged: (history) {
                          setState(() {
                            _moveHistory = history;
                          });
                          // Scroll to bottom on next frame
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            if (_moveScrollController.hasClients) {
                              _moveScrollController.animateTo(
                                _moveScrollController.position.maxScrollExtent,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeOut,
                              );
                            }
                          });
                        },
                      ),
                    ),
                  ),
                ),
                _buildBottomBar(context),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildSidebar(BuildContext context) {
    return Container(
      width: 350,
      color: Colors.blueGrey[50],
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: _buildMoveHistorySection(),
          ),
          const Divider(height: 1),
          Expanded(
            flex: 1,
            child: _buildAppHistorySection(),
          ),
        ],
      ),
    );
  }

  Widget _buildMoveHistorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            'Move History Log',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: _moveHistory.isEmpty
              ? const Center(
                  child: Text(
                    'No moves yet.\nStart by removing a peg!',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              : Scrollbar(
                  controller: _moveScrollController,
                  thumbVisibility: true,
                  trackVisibility: true,
                  thickness: 8.0,
                  interactive: true,
                  radius: const Radius.circular(4),
                  child: ListView.builder(
                    controller: _moveScrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.only(bottom: 16),
                    itemCount: _moveHistory.length,
                    itemBuilder: (context, index) {
                      final move = _moveHistory[index];
                      if (move.to == 0) {
                        return ListTile(
                          dense: true,
                          leading: CircleAvatar(
                            radius: 12,
                            child: Text('${index + 1}', style: const TextStyle(fontSize: 10)),
                          ),
                          title: Text('Removed peg ${move.from}'),
                        );
                      }
                      return ListTile(
                        dense: true,
                        leading: CircleAvatar(
                          radius: 12,
                          child: Text('${index + 1}', style: const TextStyle(fontSize: 10)),
                        ),
                        title: Text('Jumped ${move.from} to ${move.to}'),
                        subtitle: Text('Over peg ${move.over}'),
                      );
                    },
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildAppHistorySection({bool compact = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, compact ? 4 : 8),
          child: Text(
            'History of this App',
            style: TextStyle(
              fontSize: compact ? 16 : 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: Scrollbar(
            controller: _appHistoryScrollController,
            thumbVisibility: true,
            trackVisibility: true,
            thickness: 8.0,
            interactive: true,
            radius: const Radius.circular(4),
            child: SingleChildScrollView(
              controller: _appHistoryScrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('About the Project:'),
                  const Text(
                    'This project is developed cooperatively by members of the Tampa Bay Android Developers Group and GDG SunCoast. It serves as a demonstration of Flutter\'s cross-platform capabilities, bringing a classic puzzle game to the web and mobile devices with a modern responsive UI.',
                  ),
                  const SizedBox(height: 12),
                  _buildSectionTitle('Development History:'),
                  const Text('• v1.0: Initial CLI version written in Dart to test the recursive solving algorithm.'),
                  const Text('• v2.0: First Flutter implementation focusing on basic canvas drawing and drag-and-drop mechanics.'),
                  const Text('• v2.5: Added support for different peg colors and basic score tracking.'),
                  const Text('• v3.0: Major UI overhaul with a responsive layout (Sidebar for wide screens, Bottom Bar for mobile).'),
                  const Text('• v3.1: Implemented real-time Move History Log and detailed App Background History.'),
                  const Text('• v3.2: Improved accessibility and fixed scrollbar interactions across platforms.'),
                  const SizedBox(height: 12),
                  _buildSectionTitle('Game Goal:'),
                  const Text(
                    'The goal of the Triangle Peg Game (also known as Peg Solitaire) is to remove as many pegs as possible by jumping one peg over another into an empty hole.',
                  ),
                  const Text(
                    'Ideally, you want to leave only a single peg remaining on the board. According to the original game\'s lore, leaving 1 peg makes you a "Genius", 2 pegs is "Above Average", 3 pegs is "Average", and 4 or more is just "Plain Luck".',
                  ),
                  const SizedBox(height: 12),
                  _buildSectionTitle('How to Play:'),
                  const Text('1. Start by dragging any peg off the board to create the first empty hole.'),
                  const Text('2. Move another peg by jumping it over an adjacent peg into an empty hole.'),
                  const Text('3. The jumped peg is removed from the board.'),
                  const Text('4. Continue jumping until no more moves are possible.'),
                  const SizedBox(height: 12),
                  _buildSectionTitle('Credits:'),
                  const Text('Special thanks to all the contributors from the Tampa Bay Android and GDG SunCoast communities who helped refine the game logic and UI.'),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Container(
      height: 200,
      color: Colors.blueGrey[50],
      child: Row(
        children: [
          Expanded(child: _buildMoveHistorySection()),
          const VerticalDivider(width: 1),
          Expanded(child: _buildAppHistorySection(compact: true)),
        ],
      ),
    );
  }
}
