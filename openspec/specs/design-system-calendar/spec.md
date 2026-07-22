## Purpose

Contrato do **`CpfSeguroCalendar`** — o **grid mensal** de seleção de data (Flutter
puro, sem lib externa). É o miolo aberto pelo `CpfSeguroDateField`; raramente usado
solto.

## Requirements

### Requirement: Grid mensal navegável
`CpfSeguroCalendar` SHALL renderizar um mês por vez, com navegação entre meses e
seleção de um dia. Dias fora dos limites SHALL ficar desabilitados.

#### Scenario: Escolher um dia
- **WHEN** o usuário navega e toca um dia válido
- **THEN** o dia é selecionado e retornado ao consumidor

### Requirement: Limites de data respeitados
`CpfSeguroCalendar` SHALL respeitar data mínima/máxima (ex.: datas futuras
bloqueadas para nascimento). Dias fora do intervalo NÃO SHALL ser selecionáveis.

#### Scenario: Data de nascimento
- **WHEN** o calendário é de nascimento
- **THEN** datas futuras aparecem desabilitadas

### Requirement: Miolo do DateField
`CpfSeguroCalendar` SHALL ser consumido primariamente via `CpfSeguroDateField`
(campo + bottomsheet). Uso solto SHALL ser exceção justificada.

#### Scenario: Campo de data num formulário
- **WHEN** um formulário coleta uma data
- **THEN** usa `CpfSeguroDateField` (que embrulha o Calendar), não o Calendar cru
