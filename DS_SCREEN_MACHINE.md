# CPF Seguro DS — Máquina de telas e fluxos

> Como o DS **compõe telas e fluxos a partir de user flows** — e como devolve
> isso. Amadurece o V1 (agent-composable) do [`DS_CONSOLIDATION_PLAN.md`](./DS_CONSOLIDATION_PLAN.md)
> sobre a fundação de [`DS_LANGUAGE.md`](./DS_LANGUAGE.md).

Status: proposta (v0). Documento vivo.

---

## 0. O substrato já existiu (e não pode se perder)

Antes da reestruturação M3, o catálogo tinha uma camada de **fluxos** que é
justamente a matéria-prima desta máquina. No commit `3af4b3c` (M3) ela foi
**removida do catálogo — mas continua no git** (nada perdido):

- `lib/flows/flow_kit.dart` — **DSL de fluxo** estilo mermaid: `FlowEntry =
  (título, subtítulo, diagrama, telas?)`, `FlowProcessBox` (tela/etapa),
  `FlowDecision` (decisão), setas com chip de estado/erro, raias (CAMINHO
  FELIZ / DESVIOS).
- `lib/flows/onboarding_flows.dart` · `authentication_flows.dart` — **fluxos
  minerados do app real**, com mapa `rota → fluxo` e os paths-fonte de cada tela.
- `lib/flows/mermaid_view.dart` — render do diagrama.
- `lib/flow_screen.dart` · `standalone_screen.dart` · `divergence_screen.dart`
  — telas/variações standalone.

E o que **sobreviveu, vivo, na aba SDK**:
- `lib/handoff_layout.dart` — `HandoffLayout` / `HandoffPhoneShell`: renderiza
  fluxos multi-tela em shells de celular.
- `lib/sdk_screen.dart` · `checkout_screens.dart` — fluxos de migração/onboarding
  (13 telas), cadastro (8), wallet/pagamentos (15), checkout (C0-C8).

**Decisão:** recuperar o `lib/flows/` do git e **separar** numa área própria de
Fluxos (fora do catálogo de componentes) — não deletar. É o input e o
renderizador da máquina, já meio-prontos.

---

## 1. O frame: DS como compilador

```
user flow  ──►  composição  ──►  validação  ──►  entrega
(intenção)      (roles +          (specs         (diagrama +
                 Surface +         OpenSpec        telas + código
                 manifesto)        = teste)        + relatório)
```

- **Input:** um fluxo (passos, intenção de cada passo, dados, decisões, desvios).
- **IR:** o **manifesto** de componentes (props/roles/slots/variantes/regras) +
  a **gramática Surface** (top/content/bottom).
- **Saída:** telas compostas + o diagrama do fluxo + código por plataforma +
  relatório de validação contra as specs.

O pulo do gato: **as specs OpenSpec (64) viram o teste de aceite** do que a
máquina gera. Compor é criativo; validar é determinístico.

---

## 2. Input — como um user flow é descrito

Reaproveitar o vocabulário do `flow_kit` (já provado), formalizado como dado
(não só widget):

```jsonc
{
  "fluxo": "onboarding-cadastro",
  "passos": [
    { "id": "welcome",  "intencao": "boas-vindas + CTA entrar", "surface": "hero" },
    { "id": "cpf",      "intencao": "capturar CPF", "dados": ["cpf"], "componente_hint": "ChatInput" },
    { "id": "senha",    "intencao": "criar senha", "dados": ["senha"], "criterios": true },
    { "id": "otp",      "intencao": "confirmar OTP", "dados": ["otp"] },
    { "id": "biometria","intencao": "oferecer acesso rápido", "opcional": true }
  ],
  "decisoes": [ { "em": "otp", "se": "falhou", "vai": "otp", "chip": "erro" } ],
  "raias": ["CAMINHO FELIZ", "DESVIOS"]
}
```

Duas origens de input:
1. **Minerado do app real** (como o `onboarding_flows` já fazia: rota→fluxo +
   paths-fonte). Bom pra documentar/regenerar o que existe.
2. **Autoral** (product/design descreve um fluxo novo). Bom pra criar telas
   novas.

---

## 3. Composição — o coração

Para cada passo: casar **intenção → role/componente → Surface**.

- **Manifesto** (derivado das specs + catálogo, não doc paralelo): diz quais
  componentes existem, que roles/slots aceitam, e regras de composição
  ("campo de senha pede CriteriaList", "confirmação destrutiva pede role error").
- **Gramática Surface:** cada passo vira uma Surface (top/content/bottom) com os
  componentes escolhidos nos slots.

Dois motores, hibridizados:
- **Determinístico:** hints explícitos (`componente_hint`, `surface`) → montagem
  direta. Rígido, previsível.
- **Agente:** onde o input é só intenção, um agente compõe lendo o manifesto +
  gramática, e **valida contra a spec**; itera até passar.

Começar determinístico (hints), abrir pro agente conforme o manifesto amadurece.

---

## 4. Validação — specs como teste de aceite

Toda tela composta passa por:
- **Contrato:** cada componente usado respeita sua spec OpenSpec (props/variantes
  suportadas)? Uso fora do contrato = reprovado.
- **Token:** zero estilo cru (só roles) — o mesmo lint da adoção.
- **A11y:** contraste role/on-role WCAG AA (V4).
- **Gramática:** a Surface é válida (regiões coerentes)?

Reprovou → volta pro compositor com o motivo. É o guardrail que deixa o agente
livre sem gerar lixo.

---

## 5. Entrega — como devolvemos fluxo + telas

Um "pacote de fluxo", com quatro saídas da MESMA composição:

1. **Diagrama** — o mermaid do fluxo (reusa `flow_kit` + `mermaid_view`):
   passos, decisões, desvios, chips de estado.
2. **Telas navegáveis** — cada passo renderizado em `HandoffPhoneShell` (reusa
   `handoff_layout`), navegável na ordem do fluxo, no flavor escolhido.
3. **Código** — Flutter (e depois web) de cada tela, componível no app real.
   Handoff pronto pra colar, não pseudo.
4. **Relatório** — o que passou/reprovou na validação, quais componentes/roles
   cada tela usa, e o mapa rota→fluxo (se minerado).

Superfície de entrega: uma **aba Fluxos** no catálogo (separada dos componentes)
que mostra diagrama + telas em shell + código + relatório lado a lado. Front-end
autoral possível: **Figma** (via MCP) — desenhar o flow no Figma, a máquina
devolve as telas compostas no DS.

---

## 6. Mapa de reuso (o que já existe)

| Peça | Estado | Papel na máquina |
|---|---|---|
| `flow_kit` (DSL) | deletado, recuperável (`3af4b3c~1`) | vocabulário de input + diagrama |
| `onboarding_flows`/`authentication_flows` | deletado, recuperável | fluxos minerados (fixtures reais) |
| `mermaid_view` | deletado, recuperável | render do diagrama (saída 1) |
| `handoff_layout` | **vivo** (aba SDK) | render de telas em shell (saída 2) |
| specs OpenSpec (64) | **vivo** | validação (o teste de aceite) |
| gramática Surface | **vivo** (`cpf_seguro_surface`) | layout de cada passo |
| manifesto | a construir | IR da composição |

---

## 7. Sequência de construção

1. **Recuperar + separar** `lib/flows/` numa área de Fluxos própria (não
   deletar). Religa o diagrama + os fluxos minerados.
2. **Formalizar o input** de fluxo como dado (JSON do §2), a partir do `flow_kit`.
3. **Gerar o manifesto** dos componentes das specs + catálogo (IR).
4. **Compositor determinístico** (hints → Surface + componentes) + validador.
5. **Entrega**: aba Fluxos (diagrama + shell + código + relatório).
6. **Agente** por cima (intenção → composição), specs como guardrail.
7. **Web** e **Figma-in** conforme L4/V2 maturam.
