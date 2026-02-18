import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/qr_history_item.dart';
import '../utils/history_db.dart';
import '../utils/qr_classifier.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<QRHistoryItem> _allHistory = [];
  List<QRHistoryItem> _favourites = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadData();
  }

  Future<void> _loadData() async {
    final all = await HistoryDB.instance.fetchAll();
    final favs = await HistoryDB.instance.fetchFavourites();
    setState(() {
      _allHistory = all;
      _favourites = favs;
      _loading = false;
    });
  }

  Future<void> _toggleFavourite(QRHistoryItem item) async {
    await HistoryDB.instance.toggleFavourite(item.id, !item.isFavourite);
    await _loadData();
  }

  Future<void> _deleteItem(QRHistoryItem item) async {
    await HistoryDB.instance.delete(item.id);
    await _loadData();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Deleted'),
          backgroundColor: const Color(0xFF1E1E2E),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          action: SnackBarAction(
            label: 'Undo',
            textColor: const Color(0xFF7C83FD),
            onPressed: () async {
              await HistoryDB.instance.insert(item);
              await _loadData();
            },
          ),
        ),
      );
    }
  }

  Future<void> _clearAll() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E2E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Clear All History',
            style: TextStyle(color: Colors.white, fontFamily: 'Sora')),
        content: const Text('This will delete all scanned QR history.',
            style: TextStyle(color: Color(0xFF9CA3AF))),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel', style: TextStyle(color: Color(0xFF9CA3AF))),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete All',
                style: TextStyle(color: Color(0xFFFF6B6B))),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await HistoryDB.instance.deleteAll();
      await _loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F0F1A),
        elevation: 0,
        title: const Text(
          'QR History',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Sora',
            fontWeight: FontWeight.w700,
            fontSize: 22,
          ),
        ),
        actions: [
          if (_allHistory.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep_rounded,
                  color: Color(0xFFFF6B6B)),
              tooltip: 'Clear All',
              onPressed: _clearAll,
            ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFF7C83FD),
          indicatorWeight: 3,
          labelColor: const Color(0xFF7C83FD),
          unselectedLabelColor: const Color(0xFF6B7280),
          labelStyle: const TextStyle(
              fontFamily: 'Sora', fontWeight: FontWeight.w600, fontSize: 14),
          tabs: [
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.history_rounded, size: 18),
                  const SizedBox(width: 6),
                  const Text('All'),
                  if (_allHistory.isNotEmpty) ...[
                    const SizedBox(width: 6),
                    _CountBadge(count: _allHistory.length),
                  ]
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.star_rounded, size: 18),
                  const SizedBox(width: 6),
                  const Text('Favourites'),
                  if (_favourites.isNotEmpty) ...[
                    const SizedBox(width: 6),
                    _CountBadge(count: _favourites.length, isGold: true),
                  ]
                ],
              ),
            ),
          ],
        ),
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF7C83FD)))
          : TabBarView(
              controller: _tabController,
              children: [
                _HistoryList(
                  items: _allHistory,
                  onDelete: _deleteItem,
                  onToggleFav: _toggleFavourite,
                  emptyMessage: 'No scans yet',
                  emptyIcon: Icons.qr_code_scanner_rounded,
                ),
                _HistoryList(
                  items: _favourites,
                  onDelete: _deleteItem,
                  onToggleFav: _toggleFavourite,
                  emptyMessage: 'No favourites yet\nStar a scan to save it here',
                  emptyIcon: Icons.star_outline_rounded,
                ),
              ],
            ),
    );
  }
}

class _CountBadge extends StatelessWidget {
  final int count;
  final bool isGold;
  const _CountBadge({required this.count, this.isGold = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: isGold
            ? const Color(0xFFFFC107).withOpacity(0.2)
            : const Color(0xFF7C83FD).withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        '$count',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: isGold ? const Color(0xFFFFC107) : const Color(0xFF7C83FD),
        ),
      ),
    );
  }
}

class _HistoryList extends StatelessWidget {
  final List<QRHistoryItem> items;
  final Future<void> Function(QRHistoryItem) onDelete;
  final Future<void> Function(QRHistoryItem) onToggleFav;
  final String emptyMessage;
  final IconData emptyIcon;

  const _HistoryList({
    required this.items,
    required this.onDelete,
    required this.onToggleFav,
    required this.emptyMessage,
    required this.emptyIcon,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(emptyIcon, size: 64, color: const Color(0xFF2D2D44)),
            const SizedBox(height: 16),
            Text(
              emptyMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF4B5563),
                fontSize: 16,
                fontFamily: 'Sora',
                height: 1.6,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return _HistoryCard(
          item: item,
          onDelete: () => onDelete(item),
          onToggleFav: () => onToggleFav(item),
        );
      },
    );
  }
}

class _HistoryCard extends StatelessWidget {
  final QRHistoryItem item;
  final VoidCallback onDelete;
  final VoidCallback onToggleFav;

  const _HistoryCard({
    required this.item,
    required this.onDelete,
    required this.onToggleFav,
  });

  Future<void> _launch(String content) async {
    final uri = Uri.parse(content);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  String _formatDate(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inHours < 1) return '${diff.inMinutes}m ago';
    if (diff.inDays < 1) return '${diff.inHours}h ago';
    if (diff.inDays == 1) return 'Yesterday';
    return DateFormat('dd MMM yyyy • hh:mm a').format(dt);
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(item.id),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFFF6B6B).withOpacity(0.15),
          borderRadius: BorderRadius.circular(18),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete_rounded, color: Color(0xFFFF6B6B), size: 26),
      ),
      onDismissed: (_) => onDelete(),
      child: GestureDetector(
        onTap: () => _launch(item.content),
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A2E),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: item.isFavourite
                  ? const Color(0xFFFFC107).withOpacity(0.3)
                  : const Color(0xFF2D2D44),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Emoji icon
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: const Color(0xFF7C83FD).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Center(
                    child: Text(item.emoji, style: const TextStyle(fontSize: 22)),
                  ),
                ),
                const SizedBox(width: 14),
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFF7C83FD).withOpacity(0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              item.type,
                              style: const TextStyle(
                                color: Color(0xFF7C83FD),
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Sora',
                              ),
                            ),
                          ),
                          const Spacer(),
                          Text(
                            _formatDate(item.scannedAt),
                            style: const TextStyle(
                              color: Color(0xFF4B5563),
                              fontSize: 11,
                              fontFamily: 'Sora',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item.content,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFFD1D5DB),
                          fontSize: 13,
                          fontFamily: 'Sora',
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // Star button
                GestureDetector(
                  onTap: onToggleFav,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: Icon(
                      item.isFavourite
                          ? Icons.star_rounded
                          : Icons.star_outline_rounded,
                      key: ValueKey(item.isFavourite),
                      color: item.isFavourite
                          ? const Color(0xFFFFC107)
                          : const Color(0xFF4B5563),
                      size: 24,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}