## Purpose

Contrato do **`CpfSeguroToast`** — o feedback **transitório** do resultado de uma
ação (copiado, salvo, falhou). Aparece e some sozinho; superfície glass.

## Requirements

### Requirement: Feedback transitório e auto-dismiss
`CpfSeguroToast` SHALL comunicar o resultado de uma ação e sumir sozinho, sem
exigir interação. Disparo via helper `showToast`.

#### Scenario: Chave copiada
- **WHEN** o usuário copia a chave Pix
- **THEN** um toast "Copiado" aparece e some

### Requirement: state casa com o resultado
`state` SHALL refletir o resultado (success/error/warning/info) — cor/ícone do
role, não crus.

#### Scenario: Falha ao salvar
- **WHEN** a ação falha
- **THEN** toast `state` de erro

### Requirement: Efêmero, não persistente
`CpfSeguroToast` NÃO SHALL carregar informação persistente nem ação crítica (ele
desaparece). Info que precisa ficar SHALL usar banner.

#### Scenario: Aviso de conta pausada
- **WHEN** a info precisa persistir na tela
- **THEN** é um banner (Notice/Status), não um toast
