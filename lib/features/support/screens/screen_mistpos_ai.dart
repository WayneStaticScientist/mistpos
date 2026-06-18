import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:share_plus/share_plus.dart';
import 'package:dio/dio.dart';
import 'package:mistpos/core/database/ai_database_helper.dart';
import 'package:mistpos/core/services/api/network_wrapper.dart';
import 'package:mistpos/core/services/api/auth_interceptor.dart';
import 'package:mistpos/data/models/token_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:get/get.dart';
import 'package:mistpos/data/models/company_model.dart';
import 'package:mistpos/features/support/screens/screen_ai_subscription.dart';

class ScreenMistposAi extends StatefulWidget {
  const ScreenMistposAi({super.key});

  @override
  State<ScreenMistposAi> createState() => _ScreenMistposAiState();
}

class _ScreenMistposAiState extends State<ScreenMistposAi> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  List<Map<String, dynamic>> _sessions = [];
  String? _activeSessionId;
  bool _isLoading = false;
  bool _showSessionsMobile = false;

  Set<String> _selectedSessions = {};
  bool get _isSelectionMode => _selectedSessions.isNotEmpty;

  Set<int> _selectedMessages = {};
  bool get _isMessageSelectionMode => _selectedMessages.isNotEmpty;

  stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  bool _showScrollToBottomBtn = false;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _loadSessions();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  void _scrollListener() {
    if (!_scrollController.hasClients) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    final shouldShow = (maxScroll - currentScroll) > 200;
    if (shouldShow != _showScrollToBottomBtn) {
      setState(() {
        _showScrollToBottomBtn = shouldShow;
      });
    }
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) {
          if (val == 'done' || val == 'notListening') {
            setState(() => _isListening = false);
          }
        },
        onError: (val) => setState(() => _isListening = false),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            _controller.text = val.recognizedWords;
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  Future<void> _loadSessions() async {
    try {
      final data = await AiDatabaseHelper.instance.getAllSessions();
      setState(() {
        _sessions = data;
        if (_sessions.isNotEmpty) {
          _activeSessionId = _sessions.first['id'];
        } else {
          _createNewSession();
        }
      });
    } catch (_) {
      _createNewSession();
    }
    _scrollToBottom();
  }

  Future<void> _saveActiveSession() async {
    if (_activeSession != null) {
      await AiDatabaseHelper.instance.saveSession(_activeSession!);
    }
  }

  void _createNewSession() {
    final newId = DateTime.now().millisecondsSinceEpoch.toString();
    final newSession = {
      'id': newId,
      'title': 'New Conversation',
      'messages': [
        {
          'role': 'assistant',
          'content': 'Hello! I am Mistpos AI. I can analyze your sales, provide insights, manage products, and fetch real-time data from your store. How can I help you today?'
        }
      ]
    };
    setState(() {
      _sessions.insert(0, newSession);
      _activeSessionId = newId;
      _showSessionsMobile = false;
    });
    AiDatabaseHelper.instance.saveSession(newSession);
  }

  void _deleteSession(String id) async {
    await AiDatabaseHelper.instance.deleteSession(id);
    setState(() {
      _sessions.removeWhere((s) => s['id'] == id);
      if (_sessions.isEmpty) {
        _createNewSession();
      } else if (_activeSessionId == id) {
        _activeSessionId = _sessions.first['id'];
      }
    });
  }

  Future<void> _bulkDelete() async {
    for (String id in _selectedSessions) {
      await AiDatabaseHelper.instance.deleteSession(id);
    }
    setState(() {
      _sessions.removeWhere((s) => _selectedSessions.contains(s['id']));
      _selectedSessions.clear();
      if (_sessions.isEmpty) {
        _createNewSession();
      } else if (_sessions.indexWhere((s) => s['id'] == _activeSessionId) == -1) {
        _activeSessionId = _sessions.first['id'];
      }
    });
  }

  void _bulkShare() {
    String combinedText = '';
    for (var s in _sessions.where((s) => _selectedSessions.contains(s['id']))) {
      combinedText += '=== ${s['title']} ===\n\n';
      for (var m in s['messages'] ?? []) {
        final role = m['role'] == 'user' ? 'You' : 'AI';
        combinedText += '$role: ${m['content']}\n\n';
      }
    }
    Share.share(combinedText);
    setState(() => _selectedSessions.clear());
  }

  void _bulkDeleteMessages() {
    if (_activeSession != null) {
      setState(() {
        final List messages = _activeSession!['messages'];
        final indicesToRemove = _selectedMessages.toList()..sort((a, b) => b.compareTo(a));
        for (var idx in indicesToRemove) {
          if (idx >= 0 && idx < messages.length) messages.removeAt(idx);
        }
        _selectedMessages.clear();
      });
      _saveActiveSession();
    }
  }

  void _bulkShareMessages() {
    if (_activeSession != null) {
      final List messages = _activeSession!['messages'];
      String combined = '';
      final indicesToShare = _selectedMessages.toList()..sort();
      for (var idx in indicesToShare) {
        if (idx >= 0 && idx < messages.length) {
          final m = messages[idx];
          final role = m['role'] == 'user' ? 'You' : 'AI';
          combined += '$role: ${m['content']}\n\n';
        }
      }
      Share.share(combined);
      setState(() => _selectedMessages.clear());
    }
  }

  void _renameSession(String id, String currentTitle) {
    final TextEditingController renameController = TextEditingController(text: currentTitle);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Rename Session', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          content: TextField(
            controller: renameController,
            decoration: const InputDecoration(hintText: 'Enter new name'),
            autofocus: true,
            onSubmitted: (_) {
               Navigator.pop(context, renameController.text.trim());
            },
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, renameController.text.trim());
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    ).then((newTitle) async {
      if (newTitle != null && newTitle.isNotEmpty) {
        setState(() {
          final index = _sessions.indexWhere((s) => s['id'] == id);
          if (index != -1) {
            _sessions[index]['title'] = newTitle;
          }
        });
        final updatedSession = _sessions.firstWhere((s) => s['id'] == id);
        await AiDatabaseHelper.instance.saveSession(updatedSession);
      }
    });
  }

  Map<String, dynamic>? get _activeSession {
    if (_activeSessionId == null) return null;
    return _sessions.firstWhere((s) => s['id'] == _activeSessionId, orElse: () => <String, dynamic>{});
  }

  List<dynamic> get _activeMessages {
    return _activeSession?['messages'] ?? [];
  }

  Future<void> _sendMessage([String? presetText]) async {
    final text = presetText ?? _controller.text.trim();
    if (text.isEmpty) return;
    
    if (presetText == null) {
      _controller.clear();
    }

    final session = _activeSession;
    if (session == null || session.isEmpty) return;

    if (session['title'] == 'New Conversation') {
      session['title'] = text.length > 25 ? '${text.substring(0, 22)}...' : text;
    }

    setState(() {
      session['messages'].add({'role': 'user', 'content': text});
      session['messages'].add({'role': 'assistant', 'content': ''});
      _isLoading = true;
    });
    
    _scrollToBottom();
    _saveActiveSession();

    try {
      final token = TokenModel.fromStorage().accessToken;
      final dio = Dio();
      
      final response = await dio.post<ResponseBody>(
        '${Net.baseUrl}/ai/client-chat',
        data: {
          'clientDate': DateTime.now().toIso8601String(),
          'messages': session['messages'].where((m) => (m['content'] as String).isNotEmpty).toList()
        },
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "device": await getDeviceId(),
            "Accept": "text/event-stream",
          },
          responseType: ResponseType.stream,
          receiveTimeout: const Duration(minutes: 5),
          sendTimeout: const Duration(minutes: 5),
          validateStatus: (status) => true,
        ),
      );

      final stream = response.data?.stream;
      if (stream != null) {
        stream.cast<List<int>>().transform(utf8.decoder).transform(const LineSplitter()).listen(
          (line) {
            if (line.startsWith('data: ')) {
              final jsonStr = line.substring(6).trim();
              if (jsonStr == '[DONE]') {
                setState(() => _isLoading = false);
                _scrollToBottom();
                _saveActiveSession();
                return;
              }
              try {
                final decoded = jsonDecode(jsonStr);
                if (decoded['text'] != null) {
                  setState(() {
                    session['messages'].last['content'] += decoded['text'];
                  });
                  _scrollToBottom();
                } else if (decoded['error'] != null) {
                  setState(() {
                    session['messages'].last['content'] += '\n**Error:** ${decoded['error']}';
                    _isLoading = false;
                  });
                  _scrollToBottom();
                  _saveActiveSession();
                }
              } catch (_) {}
            }
          },
          onDone: () {
            setState(() => _isLoading = false);
            _scrollToBottom();
            _saveActiveSession();
          },
          onError: (error) {
            setState(() {
              session['messages'].last['content'] += '\n**Error:** Connection failed. Please try again.';
              _isLoading = false;
            });
            _scrollToBottom();
            _saveActiveSession();
          },
          cancelOnError: true,
        );
      } else {
        setState(() {
          session['messages'].last['content'] += '\n**Error:** ${response.statusCode} - Could not establish connection.';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        session['messages'].last['content'] += '\n**Error:** Could not reach the AI server. Details: $e';
        _isLoading = false;
      });
      _scrollToBottom();
      _saveActiveSession();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _performScroll();
      // Double-pass: run again after a brief delay to allow Markdown/Charts to compute final height
      Future.delayed(const Duration(milliseconds: 150), () {
        if (mounted) _performScroll();
      });
    });
  }

  void _performScroll() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    }
  }

  void _deleteMessage(int index) {
    if (_activeSession != null) {
      setState(() {
        _activeSession!['messages'].removeAt(index);
      });
      _saveActiveSession();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final isLargeScreen = width >= 768;

        return Scaffold(
          backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
          body: SafeArea(
            bottom: false,
            child: Container(
              color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
              child: Row(
                children: [
              if (isLargeScreen || _showSessionsMobile)
                Container(
                  width: isLargeScreen ? 280 : width,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : Colors.white,
                border: Border(right: BorderSide(color: isDark ? Colors.white10 : Colors.black12)),
              ),
              child: _buildSessionSidebar(isDark, !isLargeScreen),
            ),
          if (isLargeScreen || !_showSessionsMobile)
            Expanded(
              child: Column(
                children: [
                  _buildHeader(isDark, !isLargeScreen),
                  Expanded(
                    child: Stack(
                      children: [
                        _activeMessages.isEmpty || (_activeMessages.length == 1 && (_activeMessages[0]['content'] as String).isEmpty)
                            ? _buildWelcomeScreen(isDark)
                            : ListView.builder(
                                controller: _scrollController,
                                padding: const EdgeInsets.all(20),
                                itemCount: _activeMessages.length,
                                itemBuilder: (context, index) {
                                  final msg = _activeMessages[index];
                                  final isUser = msg['role'] == 'user';
                                  return _buildMessageRow(msg['content'], isUser, isDark, index);
                                },
                              ),
                        if (_showScrollToBottomBtn)
                          Positioned(
                            bottom: 16,
                            right: 16,
                            child: FloatingActionButton.small(
                              onPressed: _scrollToBottom,
                              backgroundColor: const Color(0xFF2563EB),
                              foregroundColor: Colors.white,
                              elevation: 4,
                              shape: const CircleBorder(),
                              child: const Icon(Icons.keyboard_arrow_down_rounded, size: 24),
                            ),
                          ),
                      ],
                    ),
                  ),
                  _buildInputArea(isDark),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
      },
    );
  }


  Widget _buildHeader(bool isDark, bool showMenuButton) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        border: Border(bottom: BorderSide(color: isDark ? Colors.white12 : Colors.black12)),
      ),
      child: Row(
        children: [
          if (Navigator.canPop(context))
            IconButton(
              icon: Icon(Icons.arrow_back_rounded, color: isDark ? Colors.white70 : Colors.black54),
              onPressed: () => Navigator.pop(context),
            ),
          if (showMenuButton)
            IconButton(
              icon: Icon(Icons.menu_rounded, color: isDark ? Colors.white70 : Colors.black54),
              onPressed: () => setState(() => _showSessionsMobile = true),
            ),
          if (!showMenuButton) ...[
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF2563EB), Color(0xFF7C3AED)]),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: _isMessageSelectionMode
                ? Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${_selectedMessages.length} selected',
                          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: Color(0xFF2563EB)),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(icon: const Icon(Icons.share_rounded, size: 20, color: Color(0xFF2563EB)), onPressed: _bulkShareMessages, padding: EdgeInsets.zero, constraints: const BoxConstraints()),
                      const SizedBox(width: 12),
                      IconButton(icon: const Icon(Icons.delete_outline_rounded, size: 20, color: Colors.redAccent), onPressed: _bulkDeleteMessages, padding: EdgeInsets.zero, constraints: const BoxConstraints()),
                      const SizedBox(width: 12),
                      IconButton(icon: Icon(Icons.close_rounded, size: 20, color: isDark ? Colors.white54 : Colors.black54), onPressed: () => setState(() => _selectedMessages.clear()), padding: EdgeInsets.zero, constraints: const BoxConstraints()),
                    ],
                  )
                : Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _activeSession?['title'] ?? 'Mistpos AI',
                              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: isDark ? Colors.white : const Color(0xFF0F172A)),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (!showMenuButton)
                              Text('Intelligent Assistant', style: TextStyle(fontSize: 11, color: isDark ? Colors.white54 : Colors.black54)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: showMenuButton ? 8 : 10, vertical: showMenuButton ? 4 : 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF7C3AED).withAlpha(15),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFF7C3AED).withAlpha(30)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.auto_awesome_rounded, color: Color(0xFF7C3AED), size: 14),
                            const SizedBox(width: 4),
                            Text(
                              '${CompanyModel.fromStorage()?.aiSubscriptions.tokens ?? 0}${showMenuButton ? '' : ' Credits'}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Color(0xFF7C3AED),
                              ),
                            ),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: () => Get.to(() => const ScreenAiSubscription()),
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: showMenuButton ? 6 : 8, vertical: showMenuButton ? 3 : 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF7C3AED),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: showMenuButton
                                    ? const Icon(Icons.add, size: 10, color: Colors.white)
                                    : const Text(
                                        'Upgrade',
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionSidebar(bool isDark, bool isMobile) {
    return Column(
      children: [
        // ─── Branded Header ───────────────────────────────────────────────
        Container(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? [const Color(0xFF1E3A5F), const Color(0xFF1E293B)]
                  : [const Color(0xFF2563EB).withAlpha(20), Colors.white],
            ),
            border: Border(bottom: BorderSide(color: isDark ? Colors.white.withAlpha(10) : Colors.black.withAlpha(8))),
          ),
          child: _isSelectionMode
              ? Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(color: const Color(0xFF2563EB).withAlpha(20), borderRadius: BorderRadius.circular(8)),
                      child: Text('${_selectedSessions.length} selected', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: Color(0xFF2563EB))),
                    ),
                    const Spacer(),
                    _sidebarIconBtn(Icons.share_rounded, const Color(0xFF2563EB), () => _bulkShare(), isDark),
                    const SizedBox(width: 8),
                    _sidebarIconBtn(Icons.delete_outline_rounded, Colors.redAccent, () => _bulkDelete(), isDark),
                    const SizedBox(width: 8),
                    _sidebarIconBtn(Icons.close_rounded, isDark ? Colors.white54 : Colors.black45, () => setState(() => _selectedSessions.clear()), isDark),
                  ],
                )
              : Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [Color(0xFF2563EB), Color(0xFF7C3AED)]),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [BoxShadow(color: const Color(0xFF2563EB).withAlpha(60), blurRadius: 8, offset: const Offset(0, 3))],
                      ),
                      child: const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 16),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Mistpos AI', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: isDark ? Colors.white : const Color(0xFF0F172A))),
                          Text('Chat History', style: TextStyle(fontSize: 11, color: isDark ? Colors.white38 : Colors.black38)),
                        ],
                      ),
                    ),
                    if (isMobile)
                      GestureDetector(
                        onTap: () => setState(() => _showSessionsMobile = false),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(color: isDark ? Colors.white.withAlpha(10) : Colors.black.withAlpha(8), borderRadius: BorderRadius.circular(8)),
                          child: Icon(Icons.chevron_left_rounded, size: 18, color: isDark ? Colors.white54 : Colors.black45),
                        ),
                      ),
                  ],
                ),
        ),

        // ─── New Chat Button ──────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
          child: GestureDetector(
            onTap: _createNewSession,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF2563EB), Color(0xFF3B82F6)]),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: const Color(0xFF2563EB).withAlpha(60), blurRadius: 10, offset: const Offset(0, 4))],
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_rounded, color: Colors.white, size: 18),
                  SizedBox(width: 8),
                  Text('New Chat', style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white, fontSize: 14, letterSpacing: 0.2)),
                ],
              ),
            ),
          ),
        ),

        // ─── Section Label ────────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
          child: Row(
            children: [
              Text('RECENT', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1.2, color: isDark ? Colors.white24 : Colors.black26)),
              const SizedBox(width: 8),
              Expanded(child: Divider(thickness: 0.5, color: isDark ? Colors.white12 : Colors.black12)),
            ],
          ),
        ),

        // ─── Session List ─────────────────────────────────────────────────
        Expanded(
          child: _sessions.isEmpty
              ? Center(
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Icon(Icons.chat_bubble_outline_rounded, size: 32, color: isDark ? Colors.white12 : Colors.black12),
                    const SizedBox(height: 8),
                    Text('No conversations yet', style: TextStyle(fontSize: 12, color: isDark ? Colors.white24 : Colors.black26)),
                  ]),
                )
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 16),
                  itemCount: _sessions.length,
                  itemBuilder: (context, index) {
                    final s = _sessions[index];
                    final isActive = s['id'] == _activeSessionId;
                    final isSelected = _selectedSessions.contains(s['id']);
                    return _buildSessionTile(s, isActive, isSelected, isDark);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildSessionTile(Map<String, dynamic> s, bool isActive, bool isSelected, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onLongPress: () {
          setState(() {
            if (isSelected) _selectedSessions.remove(s['id']); else _selectedSessions.add(s['id']);
          });
        },
        onTap: () {
          if (_isSelectionMode) {
            setState(() {
              if (isSelected) _selectedSessions.remove(s['id']); else _selectedSessions.add(s['id']);
            });
            return;
          }
          setState(() { _activeSessionId = s['id']; _showSessionsMobile = false; });
          _scrollToBottom();
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          margin: const EdgeInsets.symmetric(vertical: 1),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFF2563EB).withAlpha(25)
                : isActive
                    ? (isDark ? const Color(0xFF2563EB).withAlpha(18) : const Color(0xFF2563EB).withAlpha(10))
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: Border(
              left: BorderSide(
                width: 2.5,
                color: isSelected
                    ? const Color(0xFF2563EB)
                    : isActive
                        ? const Color(0xFF2563EB)
                        : Colors.transparent,
              ),
            ),
          ),
          child: Row(
            children: [
              if (isSelected)
                const Icon(Icons.check_circle_rounded, size: 16, color: Color(0xFF2563EB))
              else
                Icon(
                  isActive ? Icons.chat_bubble_rounded : Icons.chat_bubble_outline_rounded,
                  size: 15,
                  color: isActive ? const Color(0xFF2563EB) : (isDark ? Colors.white30 : Colors.black26),
                ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  s['title'] ?? 'New Conversation',
                  style: TextStyle(
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                    fontSize: 13,
                    color: isActive
                        ? (isDark ? Colors.white : const Color(0xFF0F172A))
                        : (isDark ? Colors.white60 : Colors.black54),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (!_isSelectionMode && isActive)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _tileIconBtn(Icons.edit_rounded, isDark ? Colors.white38 : Colors.black38, () => _renameSession(s['id'], s['title'] ?? '')),
                    if (_sessions.length > 1) ...[
                      const SizedBox(width: 2),
                      _tileIconBtn(Icons.delete_outline_rounded, Colors.redAccent.withAlpha(180), () => _deleteSession(s['id'])),
                    ],
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sidebarIconBtn(IconData icon, Color color, VoidCallback onTap, bool isDark) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(color: color.withAlpha(15), borderRadius: BorderRadius.circular(8)),
        child: Icon(icon, size: 16, color: color),
      ),
    );
  }

  Widget _tileIconBtn(IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(3),
        child: Icon(icon, size: 14, color: color),
      ),
    );
  }

  Widget _buildWelcomeScreen(bool isDark) {
    final prompts = [
      'Show my expenses for this month',
      'Generate an inventory valuation report',
      'How do I configure sales taxes and addendums?',
      'What were my recent stock adjustments?',
      'Create a support ticket'
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF2563EB), Color(0xFF7C3AED)]),
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: const Color(0xFF2563EB).withAlpha(50), blurRadius: 20)],
            ),
            child: const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 40),
          ),
          const SizedBox(height: 20),
          Text(
            'Mistpos AI Assistant',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: isDark ? Colors.white : const Color(0xFF0F172A)),
          ),
          const SizedBox(height: 8),
          Text(
            'Query your store statistics, inspect receipts, manage products, and create support tickets using conversational AI.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: isDark ? Colors.white54 : Colors.black54),
          ),
          const SizedBox(height: 36),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Suggestions',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: isDark ? Colors.white70 : Colors.black54),
            ),
          ),
          const SizedBox(height: 12),
          Column(
            children: prompts.map((p) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => _sendMessage(p),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E293B) : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: isDark ? Colors.white10 : Colors.black12),
                      boxShadow: [BoxShadow(color: Colors.black.withAlpha(5), blurRadius: 5)],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(p, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: isDark ? Colors.white70 : Colors.black87)),
                        ),
                        Icon(Icons.arrow_forward_rounded, size: 16, color: const Color(0xFF2563EB)),
                      ],
                    ),
                  ),
                ),
              ),
            )).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildInputArea(bool isDark) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 16, 20, 16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        border: Border(top: BorderSide(color: isDark ? Colors.white12 : Colors.black12)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: isDark ? Colors.white12 : Colors.black12),
              ),
              child: TextField(
                controller: _controller,
                style: TextStyle(color: isDark ? Colors.white : Colors.black87, fontSize: 15),
                minLines: 1,
                maxLines: 5,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  hintText: 'Ask about your sales, analytics...',
                  hintStyle: TextStyle(color: isDark ? Colors.white38 : Colors.black38),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: _listen,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _isListening ? Colors.redAccent : (isDark ? Colors.white10 : Colors.black12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _isListening ? Icons.mic_rounded : Icons.mic_none_rounded, 
                color: _isListening ? Colors.white : (isDark ? Colors.white70 : Colors.black54), 
                size: 20
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: _isLoading ? null : () => _sendMessage(),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: _isLoading 
                    ? const LinearGradient(colors: [Colors.grey, Colors.grey])
                    : const LinearGradient(colors: [Color(0xFF2563EB), Color(0xFF3B82F6)]),
                shape: BoxShape.circle,
                boxShadow: _isLoading ? [] : [BoxShadow(color: const Color(0xFF2563EB).withAlpha(80), blurRadius: 10, offset: const Offset(0, 4))],
              ),
              child: _isLoading 
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Icon(Icons.send_rounded, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageRow(String content, bool isUser, bool isDark, int index) {
    if (content.isEmpty) {
      if (!isUser && _isLoading) {
        return _buildAnimatedAnalyzing(isDark);
      }
      return const SizedBox.shrink();
    }

    final isSelected = _selectedMessages.contains(index);

    Widget messageContent;
    if (isUser) {
      messageContent = Align(
        alignment: Alignment.centerRight,
        child: Container(
          margin: const EdgeInsets.only(bottom: 24, top: 8),
          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
          decoration: BoxDecoration(
            color: const Color(0xFF2563EB),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(4),
            ),
            boxShadow: [BoxShadow(color: Colors.black.withAlpha(isDark ? 30 : 10), blurRadius: 10, offset: const Offset(0, 4))],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Text(content, style: const TextStyle(color: Colors.white, fontSize: 15)),
        ),
      );
    } else {
      String cleanContent = content.replaceAll(RegExp(r'\*⏳ Processing\.\.\.\*\n\n|\*⏳ Finalizing\.\.\.\*\n\n'), '');
      messageContent = Padding(
        padding: const EdgeInsets.only(bottom: 24, top: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(colors: [Color(0xFF2563EB), Color(0xFF7C3AED)]),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 16),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _parseChartContent(cleanContent.isEmpty && _isLoading ? 'Thinking...' : cleanContent, isDark),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(left: 38),
              child: Row(
                children: [
                  _buildActionButton(Icons.copy_rounded, 'Copy', () {
                    Clipboard.setData(ClipboardData(text: cleanContent));
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Message copied to clipboard')));
                  }, isDark),
                  const SizedBox(width: 16),
                  _buildActionButton(Icons.share_rounded, 'Share', () {
                    Share.share(cleanContent);
                  }, isDark),
                  const SizedBox(width: 16),
                  _buildActionButton(Icons.delete_outline_rounded, 'Delete', () {
                    _deleteMessage(index);
                  }, isDark),
                ],
              ),
            )
          ],
        ),
      );
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onLongPress: () {
        setState(() {
          if (isSelected) {
            _selectedMessages.remove(index);
          } else {
            _selectedMessages.add(index);
          }
        });
      },
      onTap: () {
        if (_isMessageSelectionMode) {
          setState(() {
            if (isSelected) {
              _selectedMessages.remove(index);
            } else {
              _selectedMessages.add(index);
            }
          });
        }
      },
      child: Container(
        color: isSelected ? const Color(0xFF2563EB).withAlpha(30) : Colors.transparent,
        child: messageContent,
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label, VoidCallback onTap, bool isDark) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
            children: [
              Icon(icon, size: 16, color: isDark ? Colors.white54 : Colors.black54),
              const SizedBox(width: 4),
              Text(label, style: TextStyle(fontSize: 12, color: isDark ? Colors.white54 : Colors.black54)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedAnalyzing(bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24, top: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const PulseIcon(),
          const SizedBox(width: 12),
          Text(
            'Analyzing store data...',
            style: TextStyle(
              color: isDark ? Colors.white70 : Colors.black54,
              fontSize: 14,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _parseChartContent(String cleanContent, bool isDark) {
    List<Widget> parsedWidgets = [];
    String remaining = cleanContent;

    while (remaining.contains('```chart')) {
      int start = remaining.indexOf('```chart');
      if (start > 0) {
        parsedWidgets.add(_buildMarkdownChunk(remaining.substring(0, start), isDark));
      }
      int end = remaining.indexOf('```', start + 8);
      if (end != -1) {
        String chartJson = remaining.substring(start + 8, end).trim();
        parsedWidgets.add(_buildChartFromJson(chartJson, isDark));
        remaining = remaining.substring(end + 3);
      } else {
        break;
      }
    }

    if (remaining.trim().isNotEmpty) {
      parsedWidgets.add(_buildMarkdownChunk(remaining, isDark));
    }

    return parsedWidgets;
  }

  Widget _buildMarkdownChunk(String text, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: SelectionArea(
        child: MarkdownBody(
          data: text,
          styleSheet: MarkdownStyleSheet(
            p: TextStyle(color: isDark ? Colors.white : Colors.black87, fontSize: 15, height: 1.5),
            strong: TextStyle(color: isDark ? Colors.white : Colors.black, fontWeight: FontWeight.bold),
            code: TextStyle(backgroundColor: isDark ? Colors.black26 : Colors.black12, color: const Color(0xFF2563EB), fontFamily: 'monospace'),
            listBullet: TextStyle(color: isDark ? Colors.white70 : Colors.black87),
          ),
        ),
      ),
    );
  }



  Widget _buildChartFromJson(String jsonStr, bool isDark) {
    try {
      final map = jsonDecode(jsonStr);
      final title = map['title'] ?? 'Chart';
      final data = map['data'] as Map<String, dynamic>? ?? {};

      if (data.isEmpty) return const SizedBox.shrink();

      final List<BarChartGroupData> barGroups = [];
      int i = 0;
      double maxY = 0;

      data.forEach((key, value) {
        final double val = (value is num) ? value.toDouble() : double.tryParse(value.toString()) ?? 0;
        if (val > maxY) maxY = val;
        barGroups.add(
          BarChartGroupData(
            x: i,
            barRods: [
              BarChartRodData(
                toY: val,
                gradient: const LinearGradient(colors: [Color(0xFF2563EB), Color(0xFF7C3AED)], begin: Alignment.bottomCenter, end: Alignment.topCenter),
                width: 16,
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(4), topRight: Radius.circular(4)),
              )
            ],
          ),
        );
        i++;
      });

      return Container(
        margin: const EdgeInsets.symmetric(vertical: 16),
        padding: const EdgeInsets.all(16),
        height: 250,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isDark ? Colors.white10 : Colors.black12),
          boxShadow: [BoxShadow(color: Colors.black.withAlpha(isDark ? 50 : 20), blurRadius: 10)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: isDark ? Colors.white : Colors.black87)),
            const SizedBox(height: 20),
            Expanded(
              child: BarChart(
                BarChartData(
                  barGroups: barGroups,
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (val, meta) {
                          if (val.toInt() >= data.length) return const SizedBox.shrink();
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              data.keys.elementAt(val.toInt()),
                              style: TextStyle(color: isDark ? Colors.white54 : Colors.black54, fontSize: 10),
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        },
                      ),
                    ),
                    leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: maxY > 0 ? (maxY / 4) : 1,
                    getDrawingHorizontalLine: (value) => FlLine(color: isDark ? Colors.white10 : Colors.black12, strokeWidth: 1),
                  ),
                  maxY: maxY * 1.2,
                ),
              ),
            ),
          ],
        ),
      );
    } catch (e) {
      return _buildMarkdownChunk('```json\n$jsonStr\n```', isDark);
    }
  }
}

class PulseIcon extends StatefulWidget {
  const PulseIcon({super.key});
  @override
  _PulseIconState createState() => _PulseIconState();
}

class _PulseIconState extends State<PulseIcon> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(seconds: 1), vsync: this)..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.4, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [const Color(0xFF2563EB).withAlpha(200), const Color(0xFF7C3AED).withAlpha(200)]),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 16),
      ),
    );
  }
}
