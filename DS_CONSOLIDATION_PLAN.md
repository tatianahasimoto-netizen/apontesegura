# CPF Seguro — Plano de Consolidação do DS

> Como levar o DS de um fork manual espalhado pra um sistema consolidado,
> robusto e adotado no app real — e manter isso vivo conforme o catálogo evolui.
> Camada de execução; a fundação conceitual está em [`DS_LANGUAGE.md`](./DS_LANGUAGE.md).

Status: proposta (v0). Documento vivo.

---

## 1. Diagnóstico (varredura de 2026-07)

- O app real **não consome o DS como package**. É um **fork manual** em
  `cpf-seguro-real/lib/design_system/`, com os mesmos nomes de classe religados
  aos tokens próprios do app (`ColorsPalette`, `Radii`, `Spacing`, `Shadows`,
  `Gradients`, estilos de texto). Só `CpfSeguroIcons` compartilha nome.
- Dois sistemas de token com **mesmos valores, nomes diferentes**. Migrar
  call-sites 1:1 seria brutal (Spacing 2456 refs, Palette 1786, Radius 299).
- **Integrados de fato:** 5 átomos (`Button`, `StatusTag`, `Checkbox`, `Avatar`,
  `SpotIcon`) + token `CpfSeguroIcons`.
- **Portados sem uso:** ~10 átomos no fork, referenciados só pela galeria interna.
- **Divergentes:** ~12 nativos do app duplicando função de componentes do DS.
- **Playbook-only:** ~50 componentes só no DS.
- **App-only:** ~9 nativos sem equivalente no DS.

Fonte da verdade desse estado: aba **Integração** do catálogo (`parity_screen.dart`,
lista `_items`).

---

## 2. Arquitetura-alvo

1. **DS como package** (fonte única). Separar a superfície publicável
   (`lib/design_system/` + barrel) do scaffolding do catálogo (main, spec_tables,
   telas). O app depende via git ref:
   ```yaml
   cpf_seguro_design_system:
     git: { url: https://github.com/huntercarmo-diletta/cpf-seguro-ds.git, ref: v0.x }
   ```
   Acaba o fork manual.

2. **Bridge de tokens** (baixo atrito). No app, `ColorsPalette` / `Radii` /
   `Spacing` / `Shadows` / `Gradients` / estilos viram **aliases/re-export** dos
   `CpfSeguro*` do DS. Os 2456+ call-sites ficam iguais, mas o valor passa a vir
   do DS. Unifica a fonte da verdade sem reescrever tela.

3. **Catálogo = contrato vivo.** Aba **Specs** = spec oficial; aba **Integração**
   = burndown de adoção.

---

## 3. Roadmap por fases

Usa o tracker de Integração como controle. Cada item muda de status ao migrar.

- **F0 · Fundação:** empacotar o DS (barrel + pubspec limpo), tag `v0.1`, CI de
  lint + build no repo do DS. (Depende de L0–L1 de `DS_LANGUAGE.md`: tokens/roles
  e o primitivo Surface definidos antes de estabilizar a API.)
- **F1 · Tokens:** ligar o bridge no app apontando pros tokens do DS. Validar
  paridade visual (golden/screenshot). Baixo risco, alto ganho.
- **F2 · Átomos:** plugar os ~10 "portados sem uso" nas telas, substituindo os
  nativos divergentes (TextfieldComponent→Input, CustomIconButton→IconButton,
  PinCode→OtpInput, ToggleSwitchButton→ToggleSwitch, Shimmer→LoadingSpinner/
  Skeleton, ChipInfo→InputChip). Um átomo por PR.
- **F3 · Moléculas/Organismos:** nav, top bar, sheets/modal, listas, banners.
  Consolidar os divergentes restantes.
- **F4 · App-only:** decidir absorver vs manter (DatePicker, Dropdown, WebView,
  QrCode, PeriodFilter, Banner, Modal). Absorver os genéricos pro DS.

---

## 4. Loop de atualização (catálogo → app)

1. Mudança/novo componente no repo do DS → Vercel publica o catálogo (auto) →
   Specs atualizado.
2. Tag semver + changelog.
3. App bumpa o ref no `pubspec` (ou script de sync, se mantiver vendored).
4. **Mover o status no tracker** (`_items` em `parity_screen.dart`) e dar push.
5. Widget/golden tests no DS travam regressão antes do release.

---

## 5. Capturar variações não mapeadas (do app pro catálogo)

Regra: se uma tela precisa de variante que o componente do DS não suporta e **não
dá pra expressar com os props atuais** → primeiro adiciona a variante no widget do
DS (novo enum/prop) + entra no Specs + deploya, **depois** consome. Nunca forka
em silêncio.

Variações concretas já detectadas que provavelmente pedem entrada nova:
- **Skeleton/Shimmer** (o app usa esqueleto; o DS só tem spinner) → novo
  componente ou modo `skeleton`.
- **Dropdown** (campo + variante com bottomsheet), **DatePicker**,
  **PeriodFilter** (chip + sheet).
- **Modal/Dialog de 2 ações** (o `SheetOverlay` não cobre AlertDialog).
- **Banner com ilustração + CTA**, **WebView container**, **QR code**.
- Divergências de spec já medidas (ex.: Toast radius 16 no app vs 8 no DS) →
  decidir o canônico e registrar.

---

## 6. Como as duas trilhas se encaixam

| Trilha | Doc | Objetivo |
|---|---|---|
| Linguagem (fundação) | `DS_LANGUAGE.md` (L0–L4) | tokens em camadas, roles, gramática, multiplataforma |
| Consolidação (execução) | este doc (F0–F4) | adoção real no app, fim do fork, loop de update |

Ordem prática: L0/L1 (tokens + Surface) → F0 (empacotar) → F1 (bridge) →
F2/F3 (migração guiada pelo tracker) → F4 + L4 (web).

---

## 7. Vanguarda — camada de inovação

O núcleo (F0-F4 / L0-L4) é deliberadamente **provado e conservador**. Esta
camada é onde a gente inova de propósito, sem apostar o chão firme nisso.

**Frame que amarra:** tratar o DS como **compilador** —
`intenção (roles) → composição (gramática Surface) → saída por plataforma
(Flutter / web)`, com os tokens DTCG + o manifesto de componente como IR
(representação intermediária). É o que torna o DS legível por humano, código e
agente ao mesmo tempo.

**Regra de segurança:** aposta experimental nunca entra no caminho crítico de
F0-F4. Baixo risco entra cedo; norte de longo prazo evolui em paralelo.

Legenda — maturidade: `madura` · `emergente` · `experimental`.

### V1 · DS agent-composable  (emergente · risco médio · norte de longo prazo)
O DS como linguagem que o **agente fala**: de intenção → composição correta.
Expor um **manifesto máquina-legível** por componente (props, roles, slots,
variantes suportadas, regras de composição) + a gramática Surface. Com isso, um
agente compõe "tela de confirmação de KYC" com os roles certos, e valida contra
a spec.
- Encaixe: começa em L2 (contratos/manifesto) e amadurece após F3.
- Guardrail: o manifesto é derivado das specs + do catálogo, não um doc paralelo
  que desatualiza.

### V2 · Pipeline de token Figma ↔ DTCG  (madura · risco baixo · maior ROI)
Figma Variables como fonte → export **DTCG** → **Style Dictionary** gera Dart +
CSS vars. **Code Connect** mapeia componente do Figma → componente do código.
Fecha o drift design↔código (dor nº1 de DS).
- Encaixe: L0/L3 (é a implementação da geração de tokens já prevista).
- Guardrail: uma direção canônica de fonte (Figma → código) pra não haver dois
  donos do token.

### V3 · Tracker de adoção automatizado  (emergente · risco baixo)
A aba Integração hoje é manual (`_items` em `parity_screen.dart`). Evoluir pra um
job que **varre os dois repos** (DS + app real) e gera o tracker sozinho:
adoção, divergência e drift viram métrica.
- Encaixe: depois de F1 (quando o bridge define o que é "integrado" de forma
  detectável). Alimenta o loop da §4.
- Guardrail: o gerado é a fonte; anotação manual só como override explícito.

### V4 · A11y e adaptação como semântica de 1ª classe  (emergente · risco baixo-médio)
Contraste **validado no CI** (todo par role/on-role passa WCAG AA automático) e
`reduced-motion` / `high-contrast` / dynamic type embutidos no role — não como
remendo de tela.
- Encaixe: L0 (regra de contraste já está na spec `semantic-roles`) + gate no CI
  do F0.
- Guardrail: falha de contraste **bloqueia** o merge do token, como teste.

### Fora de escopo por ora
- **Specs → testes gerados** (Scenario WHEN/THEN vira golden/visual-regression):
  interessante, mas experimental e sem tooling pronto pra OpenSpec. Opt-in
  futuro, nunca no caminho crítico.

---

## 8. Próximos passos imediatos

1. ✅ L0 (parcial): `openspec/` no repo do DS + spec-âncora `semantic-roles`.
2. L1: `CpfSeguroSurface` + aba Gramática no catálogo + spec `surface-grammar`.
3. F0: empacotar o DS + tag `v0.1` (com gate de contraste do V4).
4. V2: montar o pipeline DTCG + Style Dictionary (maior ROI, baixo risco).
