## Purpose

Definir o contrato do **`CpfSeguroButton`** — o átomo de **ação** do DS. Carrega a
intenção (primary = ação principal; secondary/tertiary descem a hierarquia; state
error = destrutivo) via `type`/`state`/`size`, nunca cor crua. Contexto de
linguagem em [`DS_LANGUAGE.md`](../../../DS_LANGUAGE.md) §1 e roles em
[`design-system-semantic-roles`](../design-system-semantic-roles/spec.md).

## Requirements

### Requirement: Ação expressa por type/state/size, nunca estilo cru
`CpfSeguroButton` SHALL receber a intenção por `type` (`CpfSeguroButtonType`),
`state` (`CpfSeguroButtonState`) e `size` (`CpfSeguroButtonSize`). NÃO SHALL
aceitar cor, raio ou tipografia crus — o visual é derivado do role pelo próprio
widget.

#### Scenario: CTA principal
- **WHEN** uma tela precisa da ação principal (Pagar, Continuar)
- **THEN** usa `CpfSeguroButton(type: CpfSeguroButtonType.primary, ...)`, sem passar `Color`/`BorderRadius`

#### Scenario: Cor crua barrada
- **WHEN** o dev tenta pintar o botão com um `Color` literal
- **THEN** não há prop pra isso; a cor vem do `type` (lint de cor crua reforça na tela)

### Requirement: Types suportados
`type` SHALL ser um de: `primary`, `secondary`, `secondaryPrimary`, `white`,
`tertiary`, `tertiaryPrimary`, `secondaryWhite`, `tertiaryWhite`. `primary` é o
fill de marca; `secondary` é outline neutro sem fundo; `secondaryWhite`/
`tertiaryWhite` são para fundo colorido/escuro (onboarding/splash).

#### Scenario: Botão sobre fundo escuro
- **WHEN** o botão fica sobre superfície colorida/escura (splash, onboarding)
- **THEN** usa `secondaryWhite` (outline branco) ou `tertiaryWhite` (fill translúcido branco), não `secondary`

### Requirement: Uma primary por superfície
Uma superfície (screen/sheet) SHALL ter no máximo UM botão `primary`. Ações
secundárias SHALL usar `secondary`/`tertiary` para preservar a hierarquia.

#### Scenario: Duas ações no rodapé
- **WHEN** uma tela tem "Pausar agora" + "Cancelar"
- **THEN** "Pausar agora" é `primary` e "Cancelar" é `secondary`, não duas `primary`

### Requirement: state error só para destrutivo
`state: CpfSeguroButtonState.error` SHALL ser usado somente em ação destrutiva
(excluir, cancelar conta). Ação não destrutiva SHALL usar `state.normal`.

#### Scenario: Excluir conta
- **WHEN** a ação apaga dados de forma irreversível
- **THEN** o botão usa `state: CpfSeguroButtonState.error`

### Requirement: Tamanhos e ícones
`size` SHALL ser `sm`, `md` ou `lg`. Ícones opcionais entram por `leadIcon` /
`trailIcon` (nome de ícone do token `CpfSeguroIcons`), nunca um widget de ícone
cru montado na tela.

#### Scenario: Botão "Continuar" com seta
- **WHEN** o botão precisa de um ícone de avanço
- **THEN** passa `trailIcon: CpfSeguroIcons.angleRightLight`, não um `Icon(...)` no label

### Requirement: disabled e gradient são modificadores, não novos types
`disabled: true` SHALL apenas rebaixar o mesmo `type` (não trocar de cor de
role). `gradient: true` SHALL aplicar o gradiente de marca apenas onde o role
permite (fill em `primary`; outline nos demais).

#### Scenario: Botão desabilitado
- **WHEN** a ação está indisponível
- **THEN** `disabled: true` mantém o `type` e reduz o contraste; não vira um `type` cinza à parte

### Requirement: Button é ação, não navegação
`CpfSeguroButton` SHALL expressar uma ação imediata na tela. Navegação entre
abas/raízes SHALL usar `CpfSeguroNav`; CTA de rodapé de fluxo usa
`CpfSeguroNavigationButton` (que compõe Button).

#### Scenario: Trocar de aba
- **WHEN** o usuário muda entre Home/Carteira
- **THEN** isso é `CpfSeguroNav`, não um `CpfSeguroButton`
