import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:open_file/open_file.dart';

import '../core/app_language.dart';
import '../core/constants/app_strings.dart';
import '../services/scan_storage.dart';
import '../core/models/scan_result.dart';
import 'result_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<ScanResult> _allScans = [];
  bool _loading = true;
  bool _downloading = false;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final scans = await ScanStorage.loadScans();
    if (!mounted) return;
    setState(() {
      _allScans = scans.reversed.toList();
      _loading = false;
    });
  }

  // ================= RESULT COLOR =================
  Color _resultColor(String disease) {
    final d = disease.toLowerCase();
    if (d.contains('healthy')) return Colors.green;
    if (d.contains('blight')) return Colors.orange;
    if (d.contains('phyllosticta')) return Colors.red;
    return Colors.black;
  }

  // ================= LOADER =================
  void _showDownloadingDialog(AppStrings strings) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        content: Row(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(width: 16),
            Expanded(child: Text(strings.generatingPdf)),
          ],
        ),
      ),
    );
  }

  void _hideDownloadingDialog() {
    if (Navigator.canPop(context)) Navigator.pop(context);
  }

  // ================= PDF DOWNLOAD =================
  Future<void> _downloadPdf(AppStrings strings) async {
    if (_allScans.isEmpty || _downloading) return;

    setState(() => _downloading = true);
    _showDownloadingDialog(strings);

    await Future.delayed(const Duration(seconds: 1));

    try {
      final pdf = pw.Document();

      pw.MemoryImage? logo;
      try {
        final data = await rootBundle.load('assets/images/logo.png');
        logo = pw.MemoryImage(data.buffer.asUint8List());
      } catch (_) {}

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(24),

          header: (_) => pw.Row(
            children: [
              if (logo != null) pw.Image(logo, width: 40, height: 40),
              pw.SizedBox(width: 12),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    strings.appName,
                    style: pw.TextStyle(
                      fontSize: 16,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.Text(
                    strings.historyPdfSubtitle,
                    style: const pw.TextStyle(
                      fontSize: 10,
                      color: PdfColors.grey700,
                    ),
                  ),
                ],
              ),
            ],
          ),

          footer: (context) => pw.Align(
            alignment: pw.Alignment.centerRight,
            child: pw.Text(
              "${strings.page} ${context.pageNumber}/${context.pagesCount}",
              style: const pw.TextStyle(fontSize: 10),
            ),
          ),

          build: (_) => [
            pw.SizedBox(height: 16),
            pw.Table(
              border: pw.TableBorder.all(color: PdfColors.grey),
              children: [
                pw.TableRow(
                  decoration:
                  const pw.BoxDecoration(color: PdfColors.grey300),
                  children: [
                    _tableHeader(strings.image),
                    _tableHeader(strings.disease),
                    _tableHeader(strings.confidence),
                    _tableHeader(strings.date),
                  ],
                ),
                ..._allScans.map(
                      (s) => _buildPdfRow(s, strings),
                ),
              ],
            ),
          ],
        ),
      );

      final file = File(
        '/storage/emulated/0/Download/Cardamom_Scan_History_${DateTime.now().millisecondsSinceEpoch}.pdf',
      );
      await file.writeAsBytes(await pdf.save());

      _hideDownloadingDialog();
      setState(() => _downloading = false);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(strings.pdfDownloaded)),
      );

      await OpenFile.open(file.path);
    } catch (e) {
      _hideDownloadingDialog();
      setState(() => _downloading = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${strings.pdfFailed}: $e")),
      );
    }
  }

  pw.TableRow _buildPdfRow(ScanResult scan, AppStrings strings) {
    pw.Widget imageCell;
    try {
      final file = File(scan.imagePath);
      imageCell = file.existsSync()
          ? pw.Image(
        pw.MemoryImage(file.readAsBytesSync()),
        width: 60,
        height: 60,
        fit: pw.BoxFit.cover,
      )
          : pw.Text("N/A");
    } catch (_) {
      imageCell = pw.Text("Error");
    }

    return pw.TableRow(
      children: [
        pw.Padding(padding: const pw.EdgeInsets.all(6), child: imageCell),
        _tableCell(strings.localizedDisease(scan.disease)),
        _tableCell("${(scan.confidence * 100).toStringAsFixed(1)}%"),
        _tableCell(_formatDate(scan.timestamp)),
      ],
    );
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppLanguage>(
      valueListenable: appLanguage,
      builder: (_, lang, __) {
        final strings = AppStrings.of(lang);

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.green.shade700,
            title: Text(
              strings.history,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            actions: [
              if (!_loading && _allScans.isNotEmpty)
                IconButton(
                  icon: _downloading
                      ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                      : const Icon(Icons.download, color: Colors.white),
                  tooltip: strings.downloadPdf,
                  onPressed:
                  _downloading ? null : () => _downloadPdf(strings),
                ),
            ],
          ),

          body: _loading
              ? const Center(child: CircularProgressIndicator())
              : _allScans.isEmpty
              ? Center(child: Text(strings.noHistory))
              : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _allScans.length,
            itemBuilder: (_, i) {
              final scan = _allScans[i];
              return ListTile(
                leading: Image.file(
                  File(scan.imagePath),
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
                title: Text(
                  strings.localizedDisease(scan.disease),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _resultColor(scan.disease),
                  ),
                ),
                subtitle: Text(
                  "${strings.confidence}: ${(scan.confidence * 100).toStringAsFixed(1)}%",
                ),
                trailing: Text(_formatDate(scan.timestamp)),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ResultScreen(result: scan),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  String _formatDate(DateTime t) =>
      "${t.day}/${t.month}/${t.year} ${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}";
}

// ================= PDF HELPERS =================
pw.Widget _tableHeader(String text) => pw.Padding(
  padding: const pw.EdgeInsets.all(8),
  child: pw.Text(
    text,
    style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11),
  ),
);

pw.Widget _tableCell(String text) => pw.Padding(
  padding: const pw.EdgeInsets.all(8),
  child: pw.Text(text, style: const pw.TextStyle(fontSize: 10)),
);
