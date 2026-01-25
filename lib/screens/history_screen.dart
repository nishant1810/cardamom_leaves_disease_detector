import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../services/scan_storage.dart';
import '../core/models/scan_result.dart';
import 'result_screen.dart';

enum HistoryFilter { all, healthy, diseased }

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<ScanResult> _allScans = [];
  Set<int> _selected = {};
  bool _loading = true;
  bool _selectionMode = false;
  HistoryFilter _filter = HistoryFilter.all;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final scans = await ScanStorage.loadScans();
    setState(() {
      _allScans = scans.reversed.toList();
      _loading = false;
      _selected.clear();
      _selectionMode = false;
    });
  }

  // ================= FILTER =================
  List<ScanResult> get _filteredScans {
    switch (_filter) {
      case HistoryFilter.healthy:
        return _allScans
            .where((s) => s.label.toLowerCase().contains('healthy'))
            .toList();
      case HistoryFilter.diseased:
        return _allScans
            .where((s) => !s.label.toLowerCase().contains('healthy'))
            .toList();
      case HistoryFilter.all:
      default:
        return _allScans;
    }
  }

  // ================= SELECT ALL =================
  bool get _isAllSelected =>
      _filteredScans.isNotEmpty &&
          _selected.length == _filteredScans.length;

  void _toggleSelectAll() {
    setState(() {
      if (_isAllSelected) {
        _selected.clear();
        _selectionMode = false;
      } else {
        _selected =
            Set.from(List.generate(_filteredScans.length, (i) => i));
        _selectionMode = true;
      }
    });
  }

  // ================= EXPORT CSV =================
  Future<void> _exportCSV() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/scan_history.csv');

    final rows = [
      "Label,Confidence,Date,ImagePath",
      ..._filteredScans.map(
            (s) =>
        "${s.label},${(s.confidence * 100).toStringAsFixed(1)},${s.timestamp.toIso8601String()},${s.imagePath}",
      ),
    ];

    await file.writeAsString(rows.join('\n'));

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Exported to ${file.path}")),
    );
  }

  // ================= DELETE SELECTED =================
  Future<void> _deleteSelected() async {
    final indexes = _selected.toList()..sort((a, b) => b.compareTo(a));
    for (final i in indexes) {
      await ScanStorage.deleteScan(_allScans.length - 1 - i);
    }
    await _loadHistory();
  }

  // ================= STATUS COLOR =================
  Color _statusColor(String label, double confidence) {
    if (label.toLowerCase().contains('healthy')) return Colors.green;
    if (confidence < 0.6) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    final scans = _filteredScans;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade700,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          _selectionMode ? "${_selected.length} selected" : "Scan History",
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        actions: [
          if (_selectionMode) ...[
            // ✅ SELECT ALL / DESELECT ALL
            IconButton(
              tooltip: _isAllSelected ? "Deselect All" : "Select All",
              icon: Icon(
                _isAllSelected ? Icons.select_all : Icons.done_all,
              ),
              onPressed: _toggleSelectAll,
            ),
            IconButton(
              tooltip: "Delete selected",
              icon: const Icon(Icons.delete),
              onPressed: _deleteSelected,
            ),
          ] else ...[
            if (scans.isNotEmpty)
              IconButton(
                icon: const Icon(Icons.download),
                tooltip: "Export history",
                onPressed: _exportCSV,
              ),
            PopupMenuButton<HistoryFilter>(
              onSelected: (v) => setState(() => _filter = v),
              itemBuilder: (_) => const [
                PopupMenuItem(
                  value: HistoryFilter.all,
                  child: Text("All"),
                ),
                PopupMenuItem(
                  value: HistoryFilter.healthy,
                  child: Text("Healthy"),
                ),
                PopupMenuItem(
                  value: HistoryFilter.diseased,
                  child: Text("Diseased"),
                ),
              ],
            ),
          ],
        ],
      ),

      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : scans.isEmpty
          ? const Center(
        child: Text(
          "No scans yet.\nStart by scanning a leaf.",
          textAlign: TextAlign.center,
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: scans.length,
        itemBuilder: (context, index) {
          final scan = scans[index];
          final selected = _selected.contains(index);
          final statusColor =
          _statusColor(scan.label, scan.confidence);

          return GestureDetector(
            onLongPress: () {
              setState(() {
                _selectionMode = true;
                _selected.add(index);
              });
            },
            onTap: () {
              if (_selectionMode) {
                setState(() {
                  selected
                      ? _selected.remove(index)
                      : _selected.add(index);
                  if (_selected.isEmpty) {
                    _selectionMode = false;
                  }
                });
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ResultScreen(
                      image: File(scan.imagePath),
                      label: scan.label,
                      confidence: scan.confidence,
                    ),
                  ),
                );
              }
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 14),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: selected
                    ? Colors.green.shade50
                    : Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      File(scan.imagePath),
                      width: 70,
                      height: 70,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Text(
                          scan.label,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: statusColor,
                          ),
                        ),
                        const SizedBox(height: 6),
                        LinearProgressIndicator(
                          value: scan.confidence,
                          minHeight: 6,
                          backgroundColor:
                          Colors.grey.shade200,
                          color: statusColor,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Confidence: ${(scan.confidence * 100).toStringAsFixed(1)}%",
                          style: const TextStyle(fontSize: 12),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _formatDate(scan.timestamp),
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  if (_selectionMode)
                    Checkbox(
                      value: selected,
                      onChanged: (_) {},
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _formatDate(DateTime time) {
    return "${time.day}/${time.month}/${time.year} "
        "${time.hour.toString().padLeft(2, '0')}:"
        "${time.minute.toString().padLeft(2, '0')}";
  }
}
