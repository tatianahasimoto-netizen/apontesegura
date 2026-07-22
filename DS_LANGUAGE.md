# CPF Seguro — Design System como Linguagem

> Arquitetura do DS: como ele deixa de ser "uma pasta de widgets" e vira uma
> **linguagem de design** — tokens que carregam significado, uma gramática de
> composição, e contratos legíveis por gente, código e IA. Multiplataforma
> (mobile Flutter + web responsivo: webadmin e IB) por design.

Status: proposta de arquitetura (v0). Documento vivo — evolui junto com o DS.

---

## 0. Princípio

Um design system maduro é uma **linguagem**, não um catálogo. Airbnb chamou o
deles de DLS (Design Language System); a raiz do termo vem de *A Pattern
Language*. Uma linguagem tem três camadas, e o nosso DS espelha isso:

1. **Vocabulário** — tokens semânticos (o *significado*: "vermelho = erro").
2. **Gramática** — como os elementos se compõem em superfícies.
3. **Dicionário** — specs e guidelines que descrevem o que cada coisa significa.

O que **força** o significado é a camada de tokens + o contrato dos componentes
(API que só aceita intenção, nunca estilo cru). Specs **documentam e verificam**;
não impõem. Essa distinção guia todo o resto do documento.

---

## 1. Vocabulário — tokens em três camadas

Padrão consolidado (Material 3 color roles, Polaris, Spectrum, Lightning,
Carbon). Uma fonte, três níveis:

```
Tier 1 · PRIMITIVO      Tier 2 · SEMÂNTICO (role)     Tier 3 · COMPONENTE
#003BE0, escala cinza  →  color.error, color.secure  →  button.bg.disabled
base-4 (4..48)            text.primary, surface          input.border.focus
                          space.edge (=16)
```

- **Tier 1 (primitivo):** material bruto. Troca por *flavor* (CPF vs outro
  produto). Hoje: `CpfSeguroPalette`.
- **Tier 2 (semântico / role):** o coração da linguagem. É onde "vermelho =
  erro" mora. Hoje: `CpfSeguroScheme` + `CpfSeguroStatusTone`. **Componentes só
  consomem este nível.**
- **Tier 3 (componente):** tokens específicos derivados do semântico. Opcional
  por componente quando há decisão local recorrente.

### Regra de ouro
Componente **nunca** recebe cor/raio/spacing cru. Recebe **role/intent/tone/
size**. Cor crua no código de tela é erro de lint. Isso é o que garante que o
sistema "sabe o significado" — não a documentação.

### Roles semânticos (extensão de Scheme + StatusTone)
Cada role é um pacote de significado, não só uma cor:

| role | cor | on-color | ícone default | uso |
|---|---|---|---|---|
| `primary` | primary-04 | white | — | ação principal, marca |
| `error` / `danger` | error-04 | white | triangle-exclamation | falha, destrutivo |
| `success` | success-04 | white | circle-check | confirmação |
| `warning` | warning-04 | ink | triangle-exclamation | atenção, limite |
| `secure` | secure-03 | white | lock | KYC, pausa, proteção |
| `info` / `neutral` | neutral | ink | circle-info | informativo |

Cada role carrega também: **par de contraste garantido** (acessibilidade),
`on-role` (texto/ícone sobre a cor), e opcionalmente `subtle`/`emphasis`.

### Fonte única e geração (o que falta e é o upgrade-chave)
Adotar o formato **W3C Design Tokens (DTCG)** como fonte máquina-legível, e
gerar as saídas com **Style Dictionary** (ou equivalente):

```
tokens/*.json (DTCG)  ──Style Dictionary──►  Dart (Flutter)  +  CSS vars / JS (web)
        (fonte única)                         cpf_seguro_ds       cpf_seguro_ds_web
```

É esse elo que torna o DS **multiplataforma de verdade**: mobile e web bebem da
mesma fonte de significado. No Flutter, expor via `ThemeExtension` é o caminho
idiomático (hoje usamos `CpfSeguroTheme.schemeOf`; funciona, mas ThemeExtension
é o canônico).

---

## 2. Gramática — composição de superfícies

Toda superfície (screen, modal, bottomsheet, página web) se compõe navegando
por **regiões**. No mobile a gramática base é:

```
CpfSeguroSurface(
  top:     …,   // StatusBar + NavigationTopBar (+ Stepper)
  content: …,   // slot rolável
  bottom:  …,   // Nav | Button | Keyboard | ChatInput | ChatInput+Keyboard
)
```

As peças já existem (`CpfSeguroTopAppBar`, `CpfSeguroBottomApp`); falta o
primitivo `CpfSeguroSurface` que amarra. Screen, modal e sheet viram a **mesma
gramática** com top/bottom diferentes.

### Ressalva importante (honesta)
`Surface` é um **primitivo forte e default** (cobre ~80-90% das telas), **não a
raiz do sistema**. A raiz são os tokens + contratos. Motivos:

- Layout e semântica são eixos **ortogonais**. A linguagem é a semântica; o
  Surface é *um* substantivo do vocabulário, não a gramática inteira.
- UIs reais fogem de 3 fatias: hero full-bleed, split view, overlays, sheets
  empilhados — e, no web, **side-nav**.

Por isso a gramática é um **conjunto pequeno de regiões responsivas**, não um
molde fixo de 3 slots:

| plataforma | regiões |
|---|---|
| mobile | `top` · `content` · `bottom` |
| web (IB) | `top` · `content` · `bottom` responsivos (breakpoints) |
| web (admin) | `top` · **`side`** · `content` (+ densidade compacta p/ tabelas) |

Breakpoints e densidade (`comfortable`/`compact`) entram como **tokens**, não
como forks — é como Carbon/Fluent/Polaris tratam admin + web.

---

## 3. Dicionário — specs, contratos e guidelines

Três artefatos, cada um com um papel:

1. **Design tokens (DTCG)** = o dicionário **máquina-legível**. Fonte do
   significado pra tooling, app e agentes de IA.
2. **Catálogo interativo** (este repo, Vercel) = o dicionário **visual**. Aba
   Specs = a matriz de variantes suportadas. Aba Integração = burndown de adoção.
3. **OpenSpec** = o dicionário de **comportamento e mudança**. Já usamos no
   `app-newbold`. Formato: `Purpose` + `Requirement` (SHALL) + `Scenario`
   (WHEN/THEN). Serve pra:
   - **contrato** de cada componente (o que ele garante),
   - **change-proposals** que guiam a migração com agente.

> OpenSpec **não** é onde o significado é imposto — isso são os tokens + a API.
> OpenSpec documenta, versiona a intenção e verifica.

### Guidelines de uso
Cada componente ganha um bloco "quando usar / do & don't" (padrão Polaris e
Spectrum). É o que faz **humano** entender o significado, além da máquina.

---

## 4. Multiplataforma — uma linguagem, várias implementações

Regra: **não se cria um segundo DS.** Compartilha-se a linguagem; implementam-se
os componentes por plataforma. Como Material, Spectrum, Fluent e Carbon fazem.

```
                    ┌─────────────────────────────────────────┐
                    │      LINGUAGEM (compartilhada)           │
                    │  tokens DTCG · roles · contratos · specs │
                    └───────────────┬─────────────────────────┘
                    ┌───────────────┴───────────────┐
        ┌───────────▼───────────┐        ┌──────────▼─────────────┐
        │  cpf_seguro_ds (Dart) │        │  cpf_seguro_ds_web      │
        │  mobile (iOS/Android) │        │  React / Web Components  │
        │  Flutter              │        │  + CSS vars              │
        └───────────────────────┘        └────────────────────────┘
             app cpf-seguro-real              webadmin · IB
```

### Decisão sobre Flutter Web (opinião crua)
- **webadmin interno:** Flutter Web é aceitável pra um MVP (mesma base, entrega
  rápida). Reavaliar conforme cresce.
- **IB voltado ao cliente:** **não** prender em Flutter Web — canvas pesado,
  bundle grande, SEO fraco, acessibilidade atrás, e IB é form/tabela-heavy. Ir
  de web-nativo (React ou Web Components + CSS vars) consumindo os tokens
  gerados.

### O que garante paridade
- Mesmos **tokens** (gerados da fonte DTCG).
- Mesmos **contratos/specs** (OpenSpec) — o componente web cumpre a mesma spec
  do mobile.
- Catálogo mostra **paridade por plataforma** contra a mesma spec.

O custo real é manter duas implementações de componente. O que **não** se
duplica: significado, tokens, contrato. É o trade-off que todo DS multiplataforma
sério aceita.

---

## 5. Robustez — práticas inegociáveis

1. Tokens em 3 camadas, fonte única DTCG, geráveis.
2. Contratos estreitos: intent/role/tone/size, nunca estilo cru (lint reforça).
3. Acessibilidade no token: contraste garantido por par role/on-role; foco;
   semantics.
4. Guidelines de uso por componente.
5. Versionamento semver + changelog + política de deprecação. App fixa versão.
6. Governança: modelo de contribuição, review, dono do DS.
7. Testes de widget/golden no DS travando regressão antes do release.

---

## 6. Caminho (fases)

Encaixa acima do plano de consolidação (`DS_CONSOLIDATION_PLAN`), como camada
fundacional.

- **L0 · Linguagem:** definir tokens DTCG (3 camadas) + roles semânticos.
  Spec-âncora `semantic-roles` em OpenSpec.
- **L1 · Gramática:** `CpfSeguroSurface` (top/content/bottom) + regiões
  responsivas (side p/ web). Aba Gramática no catálogo. Spec `surface-grammar`.
- **L2 · Contratos:** uma spec OpenSpec por componente (Purpose/SHALL/Scenario)
  + guidelines de uso no catálogo.
- **L3 · Geração:** Style Dictionary da fonte DTCG → Dart. Migrar componentes
  pra consumir só roles.
- **L4 · Web:** `cpf_seguro_ds_web` consumindo os tokens gerados; primeiros
  componentes do webadmin cumprindo as mesmas specs.

---

## Referências (DS que fazem isso a sério)
Material 3 (color roles), Shopify Polaris, Adobe Spectrum, Salesforce Lightning,
Microsoft Fluent, IBM Carbon, GitHub Primer, Airbnb DLS. Formato de token: W3C
Design Tokens Community Group (DTCG). Geração: Style Dictionary. Modelo atômico:
Brad Frost (Atomic Design) — já usado nas camadas do catálogo.
