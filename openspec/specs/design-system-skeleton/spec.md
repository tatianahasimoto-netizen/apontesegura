## Purpose

Contrato do **`CpfSeguroSkeleton`** (+ **`CpfSeguroShimmer`**) — o placeholder da
**forma** do conteúdo enquanto carrega. Skeleton = a forma; Shimmer = o efeito de
atividade em loop (Motion.shimmer).

## Requirements

### Requirement: Espelha a forma do conteúdo
`CpfSeguroSkeleton` SHALL reproduzir o layout do conteúdo que vai chegar (linhas,
cards), não um bloco genérico.

#### Scenario: Lista carregando
- **WHEN** uma lista busca dados
- **THEN** aparecem skeletons no formato das linhas reais

### Requirement: Shimmer sinaliza atividade
`CpfSeguroShimmer` SHALL envolver o Skeleton para sinalizar carregamento ativo
(loop via token de Motion).

#### Scenario: Placeholder animado
- **WHEN** o conteúdo está carregando
- **THEN** o Skeleton pulsa via Shimmer

### Requirement: Conteúdo, não ação
`CpfSeguroSkeleton` SHALL ser usado para conteúdo em carga. Espera de uma AÇÃO
SHALL usar `CpfSeguroLoadingSpinner`. Após erro, SHALL trocar por
`CpfSeguroEmptyState`, não manter skeleton.

#### Scenario: Falha ao carregar
- **WHEN** a busca falha
- **THEN** troca o skeleton por um EmptyState de erro
