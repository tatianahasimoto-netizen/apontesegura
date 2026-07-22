## Purpose

Contrato do **`CpfSeguroCheckbox`** — a seleção **múltipla** (zero-ou-vários) e o
**aceite** (termos). Distinto de RadioList (única) e ToggleSwitch (config
imediata).

## Requirements

### Requirement: Seleção múltipla ou aceite
`CpfSeguroCheckbox` SHALL ser usado para marcar zero-ou-vários itens de uma lista
ou aceitar termos. NÃO SHALL ser usado para escolha única (isso é
`CpfSeguroRadioList`) nem para config on/off imediata (`CpfSeguroToggleSwitch`).

#### Scenario: Aceite de termos
- **WHEN** o usuário precisa aceitar os termos para continuar
- **THEN** um `CpfSeguroCheckbox` com o label do aceite

### Requirement: indeterminate para estado parcial
Quando um item-pai agrega filhos parcialmente marcados, SHALL usar
`indeterminate: true` (não checked/unchecked).

#### Scenario: Pai com filhos parciais
- **WHEN** alguns sub-itens estão marcados e outros não
- **THEN** o checkbox do pai é `indeterminate: true`

### Requirement: size e variant por contexto
`size` SHALL ser `sm`/`md`; `variant` SHALL ser `primary` (padrão) ou `neutral`
(superfície colorida). Sem cor crua.

#### Scenario: Checkbox sobre chip colorido
- **WHEN** o checkbox fica sobre uma superfície de destaque
- **THEN** usa `variant: CpfSeguroCheckboxVariant.neutral`
