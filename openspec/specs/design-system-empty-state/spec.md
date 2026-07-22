## Purpose

Contrato do **`CpfSeguroEmptyState`** — o estado **vazio ou de erro** de uma
lista/tela (Atividade vazia, sem conexão): ilustração + texto que orienta + ação
opcional de saída.

## Requirements

### Requirement: Vazio/erro que orienta
`CpfSeguroEmptyState` SHALL comunicar ausência de conteúdo (ou erro de carga) e
orientar o próximo passo, não só dizer "vazio".

#### Scenario: Sem atividade recente
- **WHEN** a lista de atividade está vazia
- **THEN** um EmptyState explica e sugere o que fazer

### Requirement: Ilustração por token + ação opcional
A ilustração SHALL vir por token; a ação de saída (tentar de novo, criar) é
opcional conforme o caso.

#### Scenario: Erro de conexão
- **WHEN** falta conexão
- **THEN** EmptyState (ilustração wifi) + ação "Tentar de novo"

### Requirement: Não é loading
`CpfSeguroEmptyState` NÃO SHALL ser usado como estado de carregamento (isso é
`CpfSeguroSkeleton`). A cópia NÃO SHALL culpar o usuário.

#### Scenario: Lista carregando
- **WHEN** a lista ainda está buscando
- **THEN** é Skeleton, não EmptyState
