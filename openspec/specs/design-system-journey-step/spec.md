## Purpose

Contrato do **`CpfSeguroJourneyStep`** — o stepper **vertical** da jornada de
níveis: done em azul (primary), próximo/bloqueado em cinza, conector dashed. Cada
nível carrega as ações das próprias pendências.

## Requirements

### Requirement: Estados done/next/locked
`CpfSeguroJourneyStep` SHALL representar os estados `done` (azul), `next` e
`locked` (cinza), com conector dashed (azul no trecho concluído).

#### Scenario: Nível concluído
- **WHEN** um nível foi concluído
- **THEN** o marker é azul com circle-check

### Requirement: circle-check, nunca check solto
O concluído SHALL usar sempre o circle-check; NÃO SHALL haver check sem círculo.

#### Scenario: Marcar done
- **WHEN** o passo está done
- **THEN** mostra circle-check (não um check solto)

### Requirement: Capacidades e ações da pendência
As capacidades SHALL aparecer empilhadas (uma embaixo da outra). Cada nível SHALL
trazer os botões das próprias pendências (primary no próximo, secondary no
bloqueado); pendência concluída some da lista.

#### Scenario: Nível com pendência
- **WHEN** o nível "next" tem uma ação pendente
- **THEN** o botão dessa pendência aparece no próprio passo

### Requirement: Vertical, não progresso linear
`CpfSeguroJourneyStep` SHALL ser o stepper vertical de níveis. Progresso linear
mensurável SHALL usar `CpfSeguroProgressBar`.

#### Scenario: Barra de upload
- **WHEN** o progresso é linear
- **THEN** é ProgressBar, não JourneyStep
