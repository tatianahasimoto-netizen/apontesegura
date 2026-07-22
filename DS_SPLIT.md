# CPF Seguro — Split em dois repos

> Runbook do split: `cpf-seguro-flutter` vira o **DS + doc**; nasce
> `cpf-seguro-studio` com **flows + telas + handoff**. Decisões: DS mantém sua
> doc · repo novo = `cpf-seguro-studio`. Fundação em [`DS_LANGUAGE.md`](./DS_LANGUAGE.md).

Status: proposta (v0). Executar por etapas, verificando a cada uma.

---

## 1. Inventário (verificado)

O package (`lib/design_system/`) **não importa nada** do catálogo/flows —
split limpo, sem decoupling prévio.

### Fica no repo A — `cpf-seguro-flutter` (DS + doc)
- `lib/design_system/` — a superfície do DS (package).
- `lib/cpf_seguro_design_system.dart` — barrel raiz (typedefs/export).
- `tokens/` + `sd.config.mjs` — pipeline DTCG.
- `openspec/specs/` — contratos (doc).
- Catálogo de referência: `lib/main.dart` (SEM a aba SDK), `ds_tree_screen.dart`,
  `grammar_screen.dart`, `tokens_screen.dart`, `spec_table.dart`,
  `spec_tables.dart`, `parity_screen.dart` (tracker de adoção).
- `test/tokens_parity_test.dart`, `roles_contrast_test.dart`, `vec_icon_test.dart`.
- Docs: `DS_LANGUAGE`, `DS_CONSOLIDATION_PLAN`, `DS_ADOPTION`, `DS_REBRAND`.
- Vercel: **o atual** (continua sendo a doc do DS).

### Move pro repo B — `cpf-seguro-studio` (flows + telas + handoff)
- `lib/flows/` — `flow_spec.dart`, `fixtures/`, `flow_kit.dart`,
  `mermaid_view.dart`, `onboarding_flows.dart`, `authentication_flows.dart`.
- `lib/sdk_screen.dart` · `lib/checkout_screens.dart` · `lib/handoff_layout.dart`.
- `test/flow_spec_test.dart`.
- Docs: `DS_SCREEN_MACHINE.md` (a máquina vive aqui).
- Dep nova: o package do DS (git-tag ou path em dev).
- Vercel: **novo** projeto.

### Consequências no repo A
- `lib/main.dart`: remover a aba `_Tab.sdk` + o import de `sdk_screen`.
- `pubspec.yaml`: remover `web: ^1.0.0` (só o `mermaid_view` usava, e ele foi
  pro studio).

---

## 2. Exportar o DS "da forma certa" (pré-requisito)

Antes/junto do split, fechar o F0 de empacotamento no repo A:
- Barrel único e público (`cpf_seguro_design_system.dart`) — já existe.
- `pubspec` do package limpo (sem deps de catálogo). `web` sai.
- Subir pro package o **theme-builder** (`cpfSeguroThemeData`/`CpfSeguroApp`)
  hoje no app (ver [`DS_ADOPTION.md`](./DS_ADOPTION.md)).
- Versão semver + tag. Canal: git-tag por ora (pub privado quando escalar).
- Fonte + assets já viajam no package.

---

## 3. Sequência de execução

1. **Repo B nasce** (`cpf-seguro-studio`): `flutter create` (app web) + git init.
   Criar o remoto (`gh repo create huntercarmo-diletta/cpf-seguro-studio` ou UI).
2. **Mover** os arquivos do §1 pro studio. Preservar história (opcional) via
   `git filter-repo`/subtree; ou cópia limpa se história não for crítica.
3. **Wire do studio**: `pubspec` depende do DS (git-tag; `pubspec_overrides`
   com path local em dev). `main.dart` = shell do studio (abas Fluxos/SDK/
   Standalone/Handoff). Ajustar imports `package:cpf_seguro_design_system/...`.
4. **Limpar o repo A**: remover os arquivos movidos, tirar a aba SDK do
   `main.dart`, tirar `web` do pubspec. `flutter analyze` + `build web` verdes.
5. **Verificar o studio**: `flutter analyze` + `build web` + `flutter test`.
6. **Vercel**: A continua no projeto atual; B ganha projeto novo apontando pro
   `cpf-seguro-studio`.
7. **App real**: nada muda (consome só o DS, que continua no repo A).

---

## 4. Riscos & mitigação
- **Perda de trabalho:** tudo é git; mover ≠ deletar. Repo A guarda a história
  do que saiu.
- **Handoff da esteira:** alinhar o formato do pacote de entrega (código
  colável / Code Connect / zip) — ver [`DS_SCREEN_MACHINE.md`](./DS_SCREEN_MACHINE.md) §5.
- **Dois Vercel:** confirmar variáveis/domínios de cada.

---

## 5. Esteira de handoff (a encurtar)

Hoje: aba SDK mostra telas em phone-shell → dev **reimplementa**. Alvo: a
máquina entrega **código Flutter já token-correto e spec-válido** + diagrama +
telas navegáveis + lista de componentes/roles. Dev **cola a UI e pluga a
lógica**. Ponto aberto: o formato do pacote (colável no app / Code Connect /
export). Isso vira o produto central do `cpf-seguro-studio`.
