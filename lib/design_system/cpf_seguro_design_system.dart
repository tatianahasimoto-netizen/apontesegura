/// CPF SEGURO — Design System (barrel).
///
/// Import único pra widgets/theme consumers:
/// ```dart
/// import 'package:cpf_seguro_design_system/design_system/cpf_seguro_design_system.dart';
/// ```
///
/// Organização = atomic design: TOKENS → ATOMS → MOLECULES → ORGANISMS →
/// MOTION. Cada nível só compõe do nível abaixo.
library cpf_seguro_design_system;

// ═══════════════════════════════════════════════════════════════════════════
// TOKENS — cor (raiz), gradients/shadows derivam, depois radius e tipografia
// ═══════════════════════════════════════════════════════════════════════════
// Tier 1 → 2 → 3 (flavor + modo). Widgets consomem CpfSeguroTheme.of(context).
export 'theme/cpf_seguro_palette.dart';
export 'theme/cpf_seguro_scheme.dart';
export 'theme/cpf_seguro_roles.dart';
export 'theme/cpf_seguro_theme.dart';
export 'theme/cpf_seguro_colors.dart';
export 'theme/cpf_seguro_elevation.dart';
export 'theme/cpf_seguro_gradients.dart';
export 'theme/cpf_seguro_metrics.dart';
export 'theme/cpf_seguro_breakpoints.dart';
export 'theme/cpf_seguro_fonts.dart';
export 'theme/cpf_seguro_typography.dart';
export 'theme/cpf_seguro_icon_tokens.dart';

// ═══════════════════════════════════════════════════════════════════════════
// ATOMS — primitivos indivisíveis (consomem só tokens)
// ═══════════════════════════════════════════════════════════════════════════
// Acessores de asset (ÁTOMOS): renderizam/escalam um SVG. O TOKEN é o asset
// cru — o .svg + o nome — não o widget. CpfSeguroIcon dá cor/tamanho ao ícone;
// CpfSeguroIllustrationAccessory escala a ilustração multi-cor.
export 'widgets/cpf_seguro_assets.dart' show CpfSeguroAssets;
export 'widgets/cpf_seguro_icon.dart';
export 'widgets/cpf_seguro_icon_accessory.dart';
export 'widgets/cpf_seguro_spot_icon.dart';
export 'widgets/cpf_seguro_illustration.dart';
export 'widgets/cpf_seguro_logo.dart';
export 'widgets/cpf_seguro_glass_surface.dart';
export 'widgets/cpf_seguro_status_bar.dart';
export 'widgets/cpf_seguro_bottom_home_indicator.dart';
export 'widgets/cpf_seguro_checkbox.dart';
export 'widgets/cpf_seguro_toggle_switch.dart';
export 'widgets/cpf_seguro_loading_spinner.dart';

// ═══════════════════════════════════════════════════════════════════════════
// MOLECULES — combinações simples de átomos
// ═══════════════════════════════════════════════════════════════════════════
// Wrappers de ícone e tags
export 'widgets/cpf_seguro_action.dart';
export 'widgets/cpf_seguro_avatar.dart';
export 'widgets/cpf_seguro_status_tag.dart';
// Textos de página/seção
export 'widgets/cpf_seguro_page_title.dart';
export 'widgets/cpf_seguro_section_header.dart';
export 'widgets/cpf_seguro_see_all_link.dart';
// Inputs
export 'widgets/cpf_seguro_button.dart';
export 'widgets/cpf_seguro_icon_button.dart';
export 'widgets/cpf_seguro_field.dart';
export 'widgets/cpf_seguro_input.dart';
export 'widgets/cpf_seguro_search_input.dart';
export 'widgets/cpf_seguro_input_chip.dart';
export 'widgets/cpf_seguro_info_chip.dart';
export 'widgets/cpf_seguro_radio_list.dart';
export 'widgets/cpf_seguro_otp_input.dart';
export 'widgets/cpf_seguro_menu_button.dart';
// Listas e cards
export 'widgets/cpf_seguro_app_list.dart';
export 'widgets/cpf_seguro_feature_card.dart';
export 'widgets/cpf_seguro_info_card.dart';
export 'widgets/cpf_seguro_amount.dart';
export 'widgets/cpf_seguro_quick_access_card.dart';
export 'widgets/cpf_seguro_empty_state.dart';
export 'widgets/cpf_seguro_offline_pill.dart';
// Carteira
export 'widgets/cpf_seguro_amount_display.dart';
export 'widgets/cpf_seguro_detail_row.dart';
export 'widgets/cpf_seguro_face_id_card.dart';
export 'widgets/cpf_seguro_receipt.dart';
export 'widgets/cpf_seguro_dev_inspect.dart';
export 'widgets/cpf_seguro_text.dart';
export 'widgets/cpf_seguro_gap.dart';
// Feedback e overlays leves
export 'widgets/cpf_seguro_toast.dart';
export 'widgets/cpf_seguro_tooltip.dart';

// ═══════════════════════════════════════════════════════════════════════════
// ORGANISMS — composições em superfície (consomem moléculas)
// ═══════════════════════════════════════════════════════════════════════════
// Top/bottom bars (re-exportam navigation_top_bar/stepper e nav/navigation_button)
export 'widgets/cpf_seguro_top_app_bar.dart';
export 'widgets/cpf_seguro_bottom_app.dart';
// Surface — primitivo da gramática (top/content/bottom)
export 'widgets/cpf_seguro_surface.dart';
// Banner da Home (level/pausa/doc/erro) + slot-fillers (cada um em arquivo próprio)
export 'widgets/cpf_seguro_skeleton.dart';
export 'widgets/cpf_seguro_dropdown.dart';
export 'widgets/cpf_seguro_calendar.dart';
export 'widgets/cpf_seguro_date_field.dart';
// Chat — cada componente em arquivo próprio (tokens internos não exportados)
export 'widgets/cpf_seguro_chat_bubble.dart';
export 'widgets/cpf_seguro_criteria_list.dart';
export 'widgets/cpf_seguro_chat_criteria_bubble.dart';
export 'widgets/cpf_seguro_chat_typing_indicator.dart';
export 'widgets/cpf_seguro_chat_scroll.dart';
// Chat extras — cada um em arquivo próprio
export 'widgets/cpf_seguro_chat_input.dart';
// Sheets e overlays — cada um em arquivo próprio (SheetOverlay é interno)
export 'widgets/cpf_seguro_exit_confirm_sheet.dart';
export 'widgets/cpf_seguro_password_bottom_sheet.dart';
export 'widgets/cpf_seguro_keyboard.dart';
export 'widgets/cpf_seguro_biometria_overlay.dart';

// ═══════════════════════════════════════════════════════════════════════════
// MOTION — presets de animação e transição de tela
// ═══════════════════════════════════════════════════════════════════════════
export 'widgets/cpf_seguro_animation.dart';
export 'widgets/cpf_seguro_screen_transition.dart';
