## Purpose

Contrato do **`CpfSeguroToggleSwitch`** — a config **binária de efeito imediato**
(Face ID, Botão de Pânico). Sem passo de confirmar. Distinto de Checkbox (aceite/
multi que aplica depois) e RadioList (escolha nomeada).

## Requirements

### Requirement: Efeito imediato, sem confirmar
`CpfSeguroToggleSwitch` SHALL aplicar a mudança no ato de alternar. NÃO SHALL
depender de um botão "salvar" para efetivar.

#### Scenario: Ativar Face ID
- **WHEN** o usuário liga o Face ID
- **THEN** a config é aplicada imediatamente, sem CTA de confirmação

### Requirement: Rótulo acessível
`CpfSeguroToggleSwitch` SHALL expor `semanticLabel` descrevendo o que liga/
desliga. `size` SHALL ser `sm`/`md`.

#### Scenario: Leitor de tela
- **WHEN** o foco chega no switch
- **THEN** o `semanticLabel` anuncia a config e o estado

### Requirement: Binário, não escolha nomeada
Para escolher entre opções nomeadas SHALL usar `CpfSeguroRadioList`; para aceite/
multi que aplica depois, `CpfSeguroCheckbox`.

#### Scenario: Escolher plano A/B
- **WHEN** a decisão é entre duas opções nomeadas
- **THEN** é `CpfSeguroRadioList`, não um toggle
