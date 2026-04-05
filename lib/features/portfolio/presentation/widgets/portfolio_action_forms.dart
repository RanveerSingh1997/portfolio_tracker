import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:portfolio_tracker/core/errors/app_error.dart';
import 'package:portfolio_tracker/core/localization/l10n_extensions.dart';
import 'package:portfolio_tracker/features/portfolio/domain/entities/holding.dart';
import 'package:portfolio_tracker/features/portfolio/domain/entities/portfolio_transaction.dart';
import 'package:portfolio_tracker/features/portfolio/domain/entities/portfolio_transaction_draft.dart';
import 'package:portfolio_tracker/features/portfolio/domain/entities/watchlist_item_draft.dart';

/// Opens the manual transaction bottom sheet and returns the draft input.
Future<PortfolioTransactionDraft?> showTransactionEntrySheet(
  BuildContext context, {
  required List<Holding> existingHoldings,
}) {
  return showModalBottomSheet<PortfolioTransactionDraft>(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return _TransactionEntrySheet(existingHoldings: existingHoldings);
    },
  );
}

/// Opens a small amount-entry dialog for deposit/withdraw flows.
Future<double?> showCashAmountDialog(
  BuildContext context, {
  required String title,
  required String actionLabel,
}) {
  final controller = TextEditingController();

  return showDialog<double>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(labelText: context.l10n.amountLabel),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(context.l10n.cancelAction),
          ),
          FilledButton(
            onPressed: () {
              final amount = double.tryParse(controller.text.trim());
              if (amount == null || amount <= 0) {
                return;
              }
              Navigator.of(context).pop(amount);
            },
            child: Text(actionLabel),
          ),
        ],
      );
    },
  );
}

/// Shows a snackbar for an operation that failed with an [AppError].
void showActionMessage(BuildContext context, AppError? error) {
  final message =
      error?.details ??
      (error == null ? null : context.l10n.errorMessage(error));
  if (message == null || message.isEmpty) {
    return;
  }

  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}

/// Shows a simple success/info snackbar message.
void showStatusMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}

/// Presents the exported portfolio JSON in a copy-friendly bottom sheet.
Future<void> showPortfolioExportSheet(
  BuildContext context, {
  required String rawJson,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            20,
            20,
            20,
            MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.exportPortfolioTitle,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              Flexible(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: SingleChildScrollView(child: SelectableText(rawJson)),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(context.l10n.cancelAction),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: () async {
                        await Clipboard.setData(ClipboardData(text: rawJson));
                        if (!context.mounted) {
                          return;
                        }
                        showStatusMessage(
                          context,
                          context.l10n.portfolioCopiedMessage,
                        );
                      },
                      child: Text(context.l10n.copyJsonAction),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

/// Opens the import sheet and returns the pasted JSON when submitted.
Future<String?> showPortfolioImportSheet(BuildContext context) {
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    builder: (context) => const _PortfolioImportSheet(),
  );
}

/// Opens the watchlist entry form and returns the collected draft values.
Future<WatchlistItemDraft?> showWatchlistEntrySheet(BuildContext context) {
  return showModalBottomSheet<WatchlistItemDraft>(
    context: context,
    isScrollControlled: true,
    builder: (context) => const _WatchlistEntrySheet(),
  );
}

/// Collects the fields needed to create one manual portfolio transaction.
class _TransactionEntrySheet extends StatefulWidget {
  const _TransactionEntrySheet({required this.existingHoldings});

  final List<Holding> existingHoldings;

  @override
  State<_TransactionEntrySheet> createState() => _TransactionEntrySheetState();
}

class _TransactionEntrySheetState extends State<_TransactionEntrySheet> {
  final _formKey = GlobalKey<FormState>();
  final _symbolController = TextEditingController();
  final _nameController = TextEditingController();
  final _sectorController = TextEditingController();
  final _quantityController = TextEditingController();
  final _amountController = TextEditingController();
  PortfolioTransactionType _type = PortfolioTransactionType.buy;
  DateTime _selectedDate = DateTime.now();

  @override
  void dispose() {
    _symbolController.dispose();
    _nameController.dispose();
    _sectorController.dispose();
    _quantityController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 20, 20, bottomInset + 20),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.transactionFormTitle,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<PortfolioTransactionType>(
                  initialValue: _type,
                  decoration: InputDecoration(
                    labelText: context.l10n.transactionTypeLabel,
                  ),
                  items: PortfolioTransactionType.values.map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(_typeLabel(context, type)),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value == null) {
                      return;
                    }
                    setState(() => _type = value);
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _symbolController,
                  decoration: InputDecoration(
                    labelText: context.l10n.symbolLabel,
                  ),
                  textCapitalization: TextCapitalization.characters,
                  validator: (value) => value == null || value.trim().isEmpty
                      ? context.l10n.requiredFieldError
                      : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: context.l10n.assetNameLabel,
                  ),
                  validator: (value) => value == null || value.trim().isEmpty
                      ? context.l10n.requiredFieldError
                      : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _sectorController,
                  decoration: InputDecoration(
                    labelText: context.l10n.sectorLabel,
                  ),
                ),
                if (_type != PortfolioTransactionType.dividend) ...[
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _quantityController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: InputDecoration(
                      labelText: context.l10n.quantityLabel,
                    ),
                    validator: (value) {
                      final quantity = double.tryParse((value ?? '').trim());
                      if (quantity == null || quantity <= 0) {
                        return context.l10n.positiveNumberError;
                      }
                      return null;
                    },
                  ),
                ],
                const SizedBox(height: 12),
                TextFormField(
                  controller: _amountController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: InputDecoration(
                    labelText: context.l10n.amountLabel,
                  ),
                  validator: (value) {
                    final amount = double.tryParse((value ?? '').trim());
                    if (amount == null || amount <= 0) {
                      return context.l10n.positiveNumberError;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(context.l10n.selectDateLabel),
                  subtitle: Text(
                    MaterialLocalizations.of(
                      context,
                    ).formatMediumDate(_selectedDate),
                  ),
                  trailing: const Icon(Icons.calendar_today_outlined),
                  onTap: () async {
                    final pickedDate = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (pickedDate != null) {
                      setState(() => _selectedDate = pickedDate);
                    }
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(context.l10n.cancelAction),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: _submit,
                        child: Text(context.l10n.saveAction),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _typeLabel(BuildContext context, PortfolioTransactionType type) {
    return switch (type) {
      PortfolioTransactionType.buy => context.l10n.buy,
      PortfolioTransactionType.sell => context.l10n.sell,
      PortfolioTransactionType.dividend => context.l10n.dividend,
    };
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final symbol = _symbolController.text.trim().toUpperCase();
    Holding? existingHolding;
    // Reuse existing metadata when the user enters a symbol already held.
    for (final holding in widget.existingHoldings) {
      if (holding.symbol == symbol) {
        existingHolding = holding;
        break;
      }
    }
    final name = _nameController.text.trim().isEmpty
        ? existingHolding?.name ?? ''
        : _nameController.text.trim();
    final sector = _sectorController.text.trim().isEmpty
        ? existingHolding?.sector
        : _sectorController.text.trim();

    Navigator.of(context).pop(
      PortfolioTransactionDraft(
        symbol: symbol,
        assetName: name,
        sector: sector,
        type: _type,
        amount: double.parse(_amountController.text.trim()),
        quantity: _type == PortfolioTransactionType.dividend
            ? null
            : double.parse(_quantityController.text.trim()),
        date: _selectedDate,
      ),
    );
  }
}

/// Captures a raw JSON snapshot for import back into the local portfolio state.
class _PortfolioImportSheet extends StatefulWidget {
  const _PortfolioImportSheet();

  @override
  State<_PortfolioImportSheet> createState() => _PortfolioImportSheetState();
}

class _PortfolioImportSheetState extends State<_PortfolioImportSheet> {
  final _formKey = GlobalKey<FormState>();
  final _jsonController = TextEditingController();

  @override
  void dispose() {
    _jsonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 20, 20, bottomInset + 20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.importPortfolioTitle,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _jsonController,
                minLines: 8,
                maxLines: 12,
                decoration: InputDecoration(
                  hintText: context.l10n.importPortfolioHint,
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? context.l10n.requiredFieldError
                    : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(context.l10n.cancelAction),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: () {
                        if (!_formKey.currentState!.validate()) {
                          return;
                        }
                        Navigator.of(context).pop(_jsonController.text.trim());
                      },
                      child: Text(context.l10n.importPortfolioAction),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Collects the fields required to add a symbol to the local watchlist.
class _WatchlistEntrySheet extends StatefulWidget {
  const _WatchlistEntrySheet();

  @override
  State<_WatchlistEntrySheet> createState() => _WatchlistEntrySheetState();
}

class _WatchlistEntrySheetState extends State<_WatchlistEntrySheet> {
  final _formKey = GlobalKey<FormState>();
  final _symbolController = TextEditingController();
  final _nameController = TextEditingController();
  final _sectorController = TextEditingController();
  final _targetPriceController = TextEditingController();
  final _noteController = TextEditingController();

  @override
  void dispose() {
    _symbolController.dispose();
    _nameController.dispose();
    _sectorController.dispose();
    _targetPriceController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 20, 20, bottomInset + 20),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.watchlistFormTitle,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _symbolController,
                  textCapitalization: TextCapitalization.characters,
                  decoration: InputDecoration(
                    labelText: context.l10n.symbolLabel,
                  ),
                  validator: (value) => value == null || value.trim().isEmpty
                      ? context.l10n.requiredFieldError
                      : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: context.l10n.assetNameLabel,
                  ),
                  validator: (value) => value == null || value.trim().isEmpty
                      ? context.l10n.requiredFieldError
                      : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _sectorController,
                  decoration: InputDecoration(
                    labelText: context.l10n.sectorLabel,
                  ),
                  validator: (value) => value == null || value.trim().isEmpty
                      ? context.l10n.requiredFieldError
                      : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _targetPriceController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: InputDecoration(
                    labelText: context.l10n.targetPriceLabel,
                  ),
                  validator: (value) {
                    if ((value ?? '').trim().isEmpty) {
                      return null;
                    }
                    final parsed = double.tryParse(value!.trim());
                    if (parsed == null || parsed <= 0) {
                      return context.l10n.positiveNumberError;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _noteController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: context.l10n.noteLabel,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(context.l10n.cancelAction),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: _submit,
                        child: Text(context.l10n.saveAction),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    Navigator.of(context).pop(
      WatchlistItemDraft(
        symbol: _symbolController.text.trim().toUpperCase(),
        name: _nameController.text.trim(),
        sector: _sectorController.text.trim(),
        targetPrice: _targetPriceController.text.trim().isEmpty
            ? null
            : double.parse(_targetPriceController.text.trim()),
        note: _noteController.text.trim().isEmpty
            ? null
            : _noteController.text.trim(),
      ),
    );
  }
}
