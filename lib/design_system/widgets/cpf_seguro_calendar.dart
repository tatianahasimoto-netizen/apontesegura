import 'package:flutter/widgets.dart';
import '../theme/cpf_seguro_colors.dart';
import '../theme/cpf_seguro_metrics.dart';
import '../theme/cpf_seguro_theme.dart';
import '../theme/cpf_seguro_typography.dart';
import '../theme/cpf_seguro_icon_tokens.dart';
import 'cpf_seguro_icon.dart';

/// CPF SEGURO — Calendar.
///
/// Superfície de seleção de data: grid mensal + header com navegação de mês.
/// Construída em Flutter puro (sem dependência de pacote de calendário) pra que
/// TODA a estética viva no DS. É o "corpo" que o [CpfSeguroDateField] abre num
/// bottomsheet; também pode ser embutida direta (agendamento, filtro).
///
/// - Semana começa no domingo (padrão BR): D S T Q Q S S.
/// - Dia selecionado = círculo cheio `primary` + texto branco.
/// - Fora de [firstDay]/[lastDay] = desabilitado (não tocável, apagado).
/// - Navegação de mês usa `Motion.medium`; setas desabilitam nos limites.
class CpfSeguroCalendar extends StatefulWidget {
  const CpfSeguroCalendar({
    super.key,
    this.selectedDate,
    required this.onDateSelected,
    this.firstDay,
    this.lastDay,
    this.initialMonth,
  });

  /// Data atualmente selecionada (círculo cheio). Null = nada marcado.
  final DateTime? selectedDate;

  /// Chamado ao tocar num dia habilitado.
  final ValueChanged<DateTime> onDateSelected;

  /// Limite inferior (inclusivo). Dias antes ficam desabilitados.
  final DateTime? firstDay;

  /// Limite superior (inclusivo). Dias depois ficam desabilitados.
  final DateTime? lastDay;

  /// Mês exibido ao abrir. Default: mês da [selectedDate], senão o mês de hoje
  /// (clampado aos limites).
  final DateTime? initialMonth;

  @override
  State<CpfSeguroCalendar> createState() => _CpfSeguroCalendarState();
}

class _CpfSeguroCalendarState extends State<CpfSeguroCalendar> {
  // Iniciais dos dias da semana (domingo primeiro).
  static const _weekdayInitials = ['D', 'S', 'T', 'Q', 'Q', 'S', 'S'];
  static const _monthNames = [
    'Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho',
    'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro',
  ];

  /// Primeiro dia do mês exibido (dia 1, sem hora).
  late DateTime _month;

  @override
  void initState() {
    super.initState();
    final seed = widget.initialMonth ?? widget.selectedDate ?? DateTime.now();
    _month = DateTime(seed.year, seed.month);
  }

  // Só ano/mês/dia (zera hora) pra comparar datas com segurança.
  DateTime _ymd(DateTime d) => DateTime(d.year, d.month, d.day);

  bool _isDisabled(DateTime day) {
    final d = _ymd(day);
    final first = widget.firstDay;
    final last = widget.lastDay;
    if (first != null && d.isBefore(_ymd(first))) return true;
    if (last != null && d.isAfter(_ymd(last))) return true;
    return false;
  }

  bool _isSelected(DateTime day) {
    final sel = widget.selectedDate;
    if (sel == null) return false;
    return _ymd(sel) == _ymd(day);
  }

  // O mês tem algum dia habilitável? (governa as setas de navegação.)
  bool _canGoPrev() {
    final prev = DateTime(_month.year, _month.month - 1);
    final first = widget.firstDay;
    if (first == null) return true;
    // último dia do mês anterior >= firstDay?
    final lastOfPrev = DateTime(prev.year, prev.month + 1, 0);
    return !lastOfPrev.isBefore(_ymd(first));
  }

  bool _canGoNext() {
    final next = DateTime(_month.year, _month.month + 1);
    final last = widget.lastDay;
    if (last == null) return true;
    return !next.isAfter(_ymd(last));
  }

  void _goPrev() {
    if (!_canGoPrev()) return;
    setState(() => _month = DateTime(_month.year, _month.month - 1));
  }

  void _goNext() {
    if (!_canGoNext()) return;
    setState(() => _month = DateTime(_month.year, _month.month + 1));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _header(context),
        const SizedBox(height: CpfSeguroSpacing.s3),
        _weekdayRow(context),
        const SizedBox(height: CpfSeguroSpacing.s2),
        _grid(context),
      ],
    );
  }

  Widget _header(BuildContext context) {
    final s = CpfSeguroTheme.schemeOf(context);
    final title = '${_monthNames[_month.month - 1]} ${_month.year}';
    return Row(
      children: [
        _NavButton(
          icon: CpfSeguroIcons.chevronLeftSolid,
          enabled: _canGoPrev(),
          onTap: _goPrev,
        ),
        Expanded(
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: CpfSeguroType.subheading.copyWith(color: s.textSecondary),
          ),
        ),
        _NavButton(
          icon: CpfSeguroIcons.chevronRightSolid,
          enabled: _canGoNext(),
          onTap: _goNext,
        ),
      ],
    );
  }

  Widget _weekdayRow(BuildContext context) {
    final s = CpfSeguroTheme.schemeOf(context);
    return Row(
      children: [
        for (final w in _weekdayInitials)
          Expanded(
            child: Text(
              w,
              textAlign: TextAlign.center,
              style: CpfSeguroType.labelSm.copyWith(color: s.textMuted),
            ),
          ),
      ],
    );
  }

  Widget _grid(BuildContext context) {
    // Offset do dia 1: domingo=0 … sábado=6. DateTime.weekday: seg=1…dom=7.
    final leading = _month.weekday % 7;
    final daysInMonth = DateTime(_month.year, _month.month + 1, 0).day;
    final totalCells = leading + daysInMonth;
    final rows = (totalCells / 7).ceil();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var r = 0; r < rows; r++)
          Row(
            children: [
              for (var c = 0; c < 7; c++)
                Expanded(child: _cell(context, r * 7 + c - leading + 1)),
            ],
          ),
      ],
    );
  }

  // [dayNum] pode cair fora do mês (<1 ou >dias) — nesses casos, célula vazia.
  Widget _cell(BuildContext context, int dayNum) {
    final daysInMonth = DateTime(_month.year, _month.month + 1, 0).day;
    if (dayNum < 1 || dayNum > daysInMonth) {
      return const AspectRatio(aspectRatio: 1, child: SizedBox.shrink());
    }
    final s = CpfSeguroTheme.schemeOf(context);
    final day = DateTime(_month.year, _month.month, dayNum);
    final disabled = _isDisabled(day);
    final selected = _isSelected(day);

    final color = disabled
        ? s.textMuted
        : selected
            ? CpfSeguroColors.white
            : s.fg;

    return AspectRatio(
      aspectRatio: 1,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: disabled ? null : () => widget.onDateSelected(day),
        child: Center(
          child: Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: selected
                ? const BoxDecoration(
                    color: CpfSeguroColors.primary04,
                    shape: BoxShape.circle,
                  )
                : null,
            child: Opacity(
              opacity: disabled ? 0.4 : 1,
              child: Text(
                '$dayNum',
                style: CpfSeguroType.button.copyWith(
                  color: color,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Botão de navegação de mês (chevron). Apaga quando [enabled=false].
class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  final String icon;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final s = CpfSeguroTheme.schemeOf(context);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: enabled ? onTap : null,
      child: Padding(
        padding: const EdgeInsets.all(CpfSeguroSpacing.s2),
        child: CpfSeguroIcon(
          name: icon,
          size: 16,
          color: enabled ? s.textSecondary : s.textMuted,
        ),
      ),
    );
  }
}
