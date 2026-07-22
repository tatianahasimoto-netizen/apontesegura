# Mapa de nomes de ícones — app (font) → DS (.vec)

Referência para a migração dos ícones do app `cpf-seguro-real` (font própria
`CpfSeguroIcons` = `IconData`, em `lib/modules/common/core/const/icons.dart`)
para os tokens do DS (`CpfSeguroIcons` = nome do `.vec`, renderizado via
`CpfSeguroIcon`).

Escopo real: a font do app define 541 glyphs, mas só **104 distintos são
usados** (608 call sites, 201 arquivos). Desses nomes, **94 são idênticos** no
DS e **10 precisam rename** (tabela abaixo). Não há ícone de artwork faltando.

## Como a migração REALMENTE funciona (não é call-site swap)

Achado: dos 608 usos, só **4** são `Icon(CpfSeguroIcons.x)` (wrap direto). Os
outros **~604 passam `CpfSeguroIcons.x` — que é `IconData` — como parâmetro**
(`icon:`, `leadingIcon:`, `trailingIcon:`...). O `CpfSeguroIcon` do DS é um
**Widget** e os tokens do DS são **String**; nenhum encaixa num param tipado
`IconData`. Logo trocar a constante não migra nada.

Dois casos:
- **Param tipado `Widget`** (Flutter/Material: `IconButton.icon`,
  `ListTile.trailing`): aceita `CpfSeguroIcon(name: ...)` direto.
- **Param tipado `IconData`** (widgets custom do app): NÃO aceita. Só migra
  quando o widget host vira o equivalente do DS (que recebe token String) ou
  tem sua API mudada. Pelo pivô package-first, esses widgets serão
  substituídos — refatorar o param `IconData` deles isolado é retrabalho.

**Colisão de nome:** app font e DS token são ambos a classe `CpfSeguroIcons`.
Migrar ícone solto num arquivo força import DS com alias e mistura estilos.

**Contrato de migração (atômico por arquivo):** migre TODOS os ícones de um
arquivo de uma vez, dropando o import da font e adotando o `CpfSeguroIcons` do
DS (sem alias, sem colisão). Isso só fecha quando os hosts do arquivo aceitam
ícone DS — ou seja, **a migração de ícone é faceta da migração de widgets, não
uma passada separada.** Os params `IconData` de widgets custom se aposentam com
os widgets.

Padrão do call site, quando o host aceita `Widget`:

```dart
// antes (font do app)
Icon(CpfSeguroIcons.bellLight, size: 18, color: x)
// depois (token do DS)
CpfSeguroIcon(name: CpfSeguroIcons.bellLight, size: 18, color: x)
```

## 10 que precisam rename (app → DS)

| App (font) | DS (token) | Motivo |
|---|---|---|
| `addLight` | `plusLight` | sinônimo (add = plus) |
| `barCodeSolid` | `barcodeSolid` | casing |
| `calendarRegularLight` | `calendarLight` | peso: light vs regular — CONFIRMAR VISUAL |
| `circleXMarkLight` | `circleXmarkLight` | casing |
| `circleXMarkSolid` | `circleXmarkSolid` | casing |
| `maginifyingGlassLight` | `magnifyingGlassLight` | typo do app (maginifying) |
| `penToSquare2Light` | `penToSquareLight2` | ordem do sufixo 2 |
| `qrCodeLight` | `qrcodeLight` | casing |
| `xMarkLight` | `xmarkLight` | casing |
| `xMarkSolid` | `xmarkSolid` | casing |

Observações:
- `calendarRegularLight`: o app chama de "Regular" o calendário simples (vs
  `calendar-day`/`calendar-days`) e usa o peso light. Mapeado pra
  `calendarLight` (`calendar-light`). Confirmar visual se o peso bate (DS tem
  `calendarRegular` = peso regular como alternativa).
- Variantes solid não usadas (ex `barCodeLight`, `calendarRegularSolid`) ficam
  fora — só entram se algum call site passar a usar.
- `arrow-right` já existe no DS (v0.11.2, derivado do arrow-left por rotação).

## 94 com nome idêntico (troca mecânica, sem rename)

`angleDownLight` `angleUpLight` `arrowDownLight` `arrowRightArrowLeftLight` `arrowRightFromBracketLight` `arrowRightLight` `arrowRightSolid` `arrowRightToBracketLight` `arrowRightToBracketSolid` `arrowRotateLeftLight` `arrowUpFromBracketLight` `banLight` `bellLight` `bellSolid` `buildingLight` `calendarDayLight` `cameraLight` `checkLight` `checkSolid` `chevronDownLight` `chevronLeftLight` `chevronLeftSolid` `chevronRightLight` `chevronRightSolid` `circleCheckLight` `circleCheckSolid` `circleDollarLight` `circleExclamationLight` `circleInfoLight` `circleMinusLight` `circlePlusLight` `circleQuestionLight` `circleSmallLight` `circleSmallSolid` `circleUserLight` `clockLight` `clockRotateLeftLight` `cloneLight` `creditCardLight` `deleteLeftLight` `desktopLight` `downloadLight` `ellipsisVerticalLight` `ellipsisVerticalSolid` `envelopeLight` `expandLight` `eyeLight` `eyeSlashLightFull` `fileLight` `fileLinesLightFull` `fingerprintLight` `fingerprintSolid` `gearLight` `gearsLightFull` `handWaveLight` `hashtagLockLight` `houseLight` `idCardClipLight` `idCardLight` `idCardSolid` `keyLight` `landmarkLight` `landmarkSolid` `linkLight` `lockLight` `magnifyingGlassSolid` `messagesQuestionLightFull` `minusLight` `mobileLight` `mobileSignalLight` `moneyBillTransferInLight` `moneyBillTransferOutLight` `noteLightFull` `penToSquareLight` `periodSolid` `piggyBankLight` `pixLight` `pixSolid` `receiptLight` `sendCpfSeguro` `shieldUserLightFull` `slidersLight` `slidersSolid` `trashLight` `triangleExclamationLight` `triangleExclamationSolid` `userCircleMinusLightFull` `userGearLight` `userLight` `userPenLightFull` `userSolid` `userTieLight` `usersLight` `walletLight` 
