## Purpose

Contrato do **`CpfSeguroGlassSurface`** — o fill glass (branco 80% + BackdropFilter
blur 10) dos **containers de chrome** (top bar, bottom bar, toast, sheet). Glass é
característica do container, não de um elemento solto.

## Requirements

### Requirement: Glass é do container, não do elemento
`CpfSeguroGlassSurface` SHALL ser aplicado num container de chrome (via
`CpfSeguroTopAppBar.app` / `CpfSeguroBottomApp` / `CpfSeguroToast`). StatusBar,
ChatHeader e HomeIndicator sozinhos NÃO SHALL ser glass.

#### Scenario: Barra inferior glass
- **WHEN** a bottom bar precisa do efeito glass
- **THEN** o glass vem do `CpfSeguroBottomApp`, não de cada item da barra

### Requirement: Precisa de conteúdo atrás
Para o blur ter efeito, SHALL haver conteúdo rolando ATRÁS do container glass
(extendBody / extendBodyBehindAppBar). Sem conteúdo atrás, o glass vira branco.

#### Scenario: Chat rola sob a barra
- **WHEN** a bottom bar é glass
- **THEN** o content usa extendBody e rola por trás, produzindo o blur

### Requirement: Spec única do efeito
A spec do glass (tint + sigma do blur) SHALL viver só em `CpfSeguroGlassSurface`;
mudança de spec SHALL propagar a todos os consumidores por ele.

#### Scenario: Ajustar o blur
- **WHEN** a spec do glass muda
- **THEN** muda em `CpfSeguroGlassSurface` e propaga a TopAppBar/BottomApp/Toast
