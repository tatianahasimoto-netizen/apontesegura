## Purpose

Contrato do **`CpfSeguroLoadingSpinner`** — a espera **indeterminada e curta**
(botão processando, carregar tela). Distinto de ProgressBar/Ring (progresso
conhecido) e Skeleton (placeholder de conteúdo).

## Requirements

### Requirement: Espera indeterminada
`CpfSeguroLoadingSpinner` SHALL indicar espera sem medida conhecida. Progresso
mensurável SHALL usar `CpfSeguroProgressBar`/`CpfSeguroProgressRing`.

#### Scenario: Botão enviando
- **WHEN** um botão dispara uma chamada e aguarda
- **THEN** mostra o spinner enquanto processa

### Requirement: size por contexto
`size` (3 tamanhos) SHALL casar com o contexto (inline no botão vs centro da
tela). Centraliza na área que carrega.

#### Scenario: Carregar uma tela
- **WHEN** a tela inteira está carregando
- **THEN** spinner maior centralizado

### Requirement: Conteúdo em carga usa Skeleton
Para carregar uma lista/card, SHALL preferir `CpfSeguroSkeleton` (forma) a um
spinner sobre tudo.

#### Scenario: Lista carregando
- **WHEN** uma lista está buscando dados
- **THEN** mostra Skeleton das linhas, não um spinner cobrindo a lista
