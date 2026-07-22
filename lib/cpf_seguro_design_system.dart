/// CPF SEGURO — Design System (entrypoint público do package).
///
/// Consumir no app:
/// ```dart
/// import 'package:cpf_seguro_design_system/cpf_seguro_design_system.dart' as ds;
/// ds.Amount.cashIn(value: 'R$ 560,00');
/// ds.Button(label: 'OK', onPressed: () {});
/// ```
///
/// CAMADA DE API PÚBLICA (nomes sem prefixo) — o app escreve `ds.X`. As classes
/// internas mantêm o prefixo `CpfSeguro` (detalhe de implementação, evita colisão
/// com primitivos do Flutter como Colors/Icon/Text/Radius). Trocar de DS = trocar
/// SÓ este import `as ds`: outro DS que exponha os mesmos nomes (Amount, Button,
/// Colors...) é intercambiável. É o contrato de design language da Diletta.
///
/// Os `typedef` abaixo são a superfície pública; a implementação vem do barrel
/// interno (importado E reexportado).
library cpf_seguro_design_system;

import 'design_system/cpf_seguro_design_system.dart';
export 'design_system/cpf_seguro_design_system.dart';

// ─── API pública (nomes sem prefixo) ────────────────────────────────────────
typedef Action = CpfSeguroAction;
typedef ActionDirection = CpfSeguroActionDirection;
typedef Amount = CpfSeguroAmount;
typedef AmountDisplay = CpfSeguroAmountDisplay;
typedef Animation = CpfSeguroAnimation;
typedef AnimationPreset = CpfSeguroAnimationPreset;
typedef AppList = CpfSeguroAppList;
typedef AppListRow = CpfSeguroAppListRow;
typedef AppListDayGroup = CpfSeguroAppListDayGroup;
typedef Assets = CpfSeguroAssets;
typedef Avatar = CpfSeguroAvatar;
typedef AvatarVariant = CpfSeguroAvatarVariant;
typedef Badge = CpfSeguroBadge;
typedef BiometriaOverlay = CpfSeguroBiometriaOverlay;
typedef BottomApp = CpfSeguroBottomApp;
typedef BottomHomeIndicator = CpfSeguroBottomHomeIndicator;
typedef Breakpoint = CpfSeguroBreakpoint;
typedef Breakpoints = CpfSeguroBreakpoints;
typedef Button = CpfSeguroButton;
typedef ButtonSize = CpfSeguroButtonSize;
typedef ButtonState = CpfSeguroButtonState;
typedef ButtonType = CpfSeguroButtonType;
typedef ChatBubble = CpfSeguroChatBubble;
typedef ChatBubbleTone = CpfSeguroChatBubbleTone;
typedef ChatCriteriaBubble = CpfSeguroChatCriteriaBubble;
typedef ChatFrom = CpfSeguroChatFrom;
typedef ChatInput = CpfSeguroChatInput;
typedef ChatInputCheckbox = CpfSeguroChatInputCheckbox;
typedef ChatInputType = CpfSeguroChatInputType;
typedef ChatScroll = CpfSeguroChatScroll;
typedef ChatTypingIndicator = CpfSeguroChatTypingIndicator;
typedef Calendar = CpfSeguroCalendar;
typedef Checkbox = CpfSeguroCheckbox;
typedef CheckboxSize = CpfSeguroCheckboxSize;
typedef CheckboxVariant = CpfSeguroCheckboxVariant;
typedef Colors = CpfSeguroColors;
typedef CriteriaItem = CpfSeguroCriteriaItem;
typedef CriteriaStatus = CpfSeguroCriteriaStatus;
typedef CriteriaList = CpfSeguroCriteriaList;
typedef CriteriaRow = CpfSeguroCriteriaRow;
typedef DateField = CpfSeguroDateField;
typedef DetailRow = CpfSeguroDetailRow;
typedef Dropdown = CpfSeguroDropdown;
typedef Elevation = CpfSeguroElevation;
typedef ElevationLevel = CpfSeguroElevationLevel;
typedef EmptyState = CpfSeguroEmptyState;
typedef ExitConfirmSheet = CpfSeguroExitConfirmSheet;
typedef FaceIdCard = CpfSeguroFaceIdCard;
typedef FeatureCard = CpfSeguroFeatureCard;
typedef Fonts = CpfSeguroFonts;
typedef Gap = CpfSeguroGap;
typedef GlassSurface = CpfSeguroGlassSurface;
typedef Gradients = CpfSeguroGradients;
typedef Icon = CpfSeguroIcon;
typedef IconAccessory = CpfSeguroIconAccessory;
typedef IconButton = CpfSeguroIconButton;
typedef IconButtonSize = CpfSeguroIconButtonSize;
typedef IconButtonState = CpfSeguroIconButtonState;
typedef IconButtonType = CpfSeguroIconButtonType;
typedef IconFlush = CpfSeguroIconFlush;
typedef Icons = CpfSeguroIcons;
typedef Illustration = CpfSeguroIllustration;
typedef IllustrationAccessory = CpfSeguroIllustrationAccessory;
typedef IllustrationSize = CpfSeguroIllustrationSize;
typedef IllustrationBrand = CpfSeguroIllustrationBrand;
typedef Field = CpfSeguroField;
typedef InfoCard = CpfSeguroInfoCard;
typedef Input = CpfSeguroInput;
typedef InputChip = CpfSeguroInputChip;
typedef InfoChip = CpfSeguroInfoChip;
typedef InfoChipTone = CpfSeguroInfoChipTone;
typedef InputType = CpfSeguroInputType;
typedef Keyboard = CpfSeguroKeyboard;
typedef KeyboardIndicator = CpfSeguroKeyboardIndicator;
typedef LeftAccessory = CpfSeguroLeftAccessory;
typedef LoadingSpinner = CpfSeguroLoadingSpinner;
typedef Skeleton = CpfSeguroSkeleton;
typedef Shimmer = CpfSeguroShimmer;
typedef Logo = CpfSeguroLogo;
typedef LogoVariant = CpfSeguroLogoVariant;
typedef MenuButton = CpfSeguroMenuButton;
typedef MenuButtonVariant = CpfSeguroMenuButtonVariant;
typedef MiddleAccessory = CpfSeguroMiddleAccessory;
typedef MiddleSize = CpfSeguroMiddleSize;
typedef Motion = CpfSeguroMotion;
typedef MotionSpec = CpfSeguroMotionSpec;
typedef Nav = CpfSeguroNav;
typedef NavItem = CpfSeguroNavItem;
typedef NavRightIcon = CpfSeguroNavRightIcon;
typedef NavTab = CpfSeguroNavTab;
typedef NavigationAction = CpfSeguroNavigationAction;
typedef NavigationButton = CpfSeguroNavigationButton;
typedef NavigationLeftAccessory = CpfSeguroNavigationLeftAccessory;
typedef NavigationRightAccessory = CpfSeguroNavigationRightAccessory;
typedef NavigationTopBar = CpfSeguroNavigationTopBar;
typedef OfflinePill = CpfSeguroOfflinePill;
typedef OtpInput = CpfSeguroOtpInput;
typedef PageTitle = CpfSeguroPageTitle;
typedef Palette = CpfSeguroPalette;
typedef PasswordBottomSheet = CpfSeguroPasswordBottomSheet;
typedef QuickAccessCard = CpfSeguroQuickAccessCard;
typedef QuickAccessState = CpfSeguroQuickAccessState;
typedef RadioList = CpfSeguroRadioList;
typedef RadioOption = CpfSeguroRadioOption;
typedef Radius = CpfSeguroRadius;
typedef Receipt = CpfSeguroReceipt;
typedef ReceiptRow = CpfSeguroReceiptRow;
typedef ReceiptSection = CpfSeguroReceiptSection;
typedef RightAccessory = CpfSeguroRightAccessory;
typedef Role = CpfSeguroRole;
typedef RoleStyle = CpfSeguroRoleStyle;
typedef Roles = CpfSeguroRoles;
typedef Scheme = CpfSeguroScheme;
typedef ScreenDirection = CpfSeguroScreenDirection;
typedef ScreenTransition = CpfSeguroScreenTransition;
typedef SearchInput = CpfSeguroSearchInput;
typedef SectionHeader = CpfSeguroSectionHeader;
typedef SeeAllLink = CpfSeguroSeeAllLink;
typedef Spacing = CpfSeguroSpacing;
typedef SpinnerSize = CpfSeguroSpinnerSize;
typedef SpotIcon = CpfSeguroSpotIcon;
typedef SpotState = CpfSeguroSpotState;
typedef SpotType = CpfSeguroSpotType;
typedef StatusBar = CpfSeguroStatusBar;
typedef StatusTag = CpfSeguroStatusTag;
typedef StatusTagData = CpfSeguroStatusTagData;
typedef StatusTone = CpfSeguroStatusTone;
typedef Stepper = CpfSeguroStepper;
typedef Surface = CpfSeguroSurface;
typedef Text = CpfSeguroText;
typedef Theme = CpfSeguroTheme;
typedef ThemeScope = CpfSeguroThemeScope;
typedef Toast = CpfSeguroToast;
typedef ToastState = CpfSeguroToastState;
typedef ToggleSize = CpfSeguroToggleSize;
typedef ToggleSwitch = CpfSeguroToggleSwitch;
typedef Tooltip = CpfSeguroTooltip;
typedef TooltipSide = CpfSeguroTooltipSide;
typedef TooltipSize = CpfSeguroTooltipSize;
typedef TooltipStyle = CpfSeguroTooltipStyle;
typedef TopAppBar = CpfSeguroTopAppBar;
typedef Type = CpfSeguroType;
