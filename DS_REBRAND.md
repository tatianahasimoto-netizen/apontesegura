# CPF Seguro DS — Rebrand / novos DS por flavor

> Como derivar OUTRO design system a partir deste — trocando o look & feel sem
> tocar na anatomia dos componentes. É o "white-label" da linguagem.
> Fundação em [`DS_LANGUAGE.md`](./DS_LANGUAGE.md) (tokens em 3 camadas).

Status: proposta (v0). Documento vivo.

---

## 1. Princípio: flavor troca TOKEN, não ANATOMIA

Os componentes só consomem **roles** (Tier 2), nunca estilo cru. Então o look &
feel inteiro vive nos tokens. Um novo DS = um novo **flavor de token**:

```
tokens/flavors/<marca>.tokens.json   →  Style Dictionary  →  CpfSeguroPalette.<marca> + scheme
```

Como todo componente lê role, ele **re-skina de graça**. O que NÃO muda: a
estrutura/anatomia de cada componente, os contratos (specs), a gramática Surface.

**Linha vermelha:** se a marca precisa de anatomia diferente (outra composição
de slots, outro comportamento), isso é **fork**, não flavor. Flavor é troca de
pele; fork é troca de esqueleto. Manter essa fronteira é o que impede o DS de
virar espaguete.

---

## 2. O que é "look & feel" (tudo é token, tudo é flavorável)

| Eixo | Token | O que muda na cara |
|---|---|---|
| **Cor** | primitivos + roles (primary/error/success/secure/…) | a identidade |
| **Raio** | escala de radius (0…200) | sharp (corporativo) vs pill (amigável) |
| **Tipografia** | família + escala (display…label) | voz da marca |
| **Elevação** | receitas de shadow | flat (moderno) vs sombreado (profundidade) |
| **Gradiente** | brandLift etc. | brilho/acabamento |
| **Motion** | duração + easing | seco/rápido vs suave/fluido |
| **Densidade** | spacing base + `comfortable`/`compact` | mobile vs admin/tabela |

Trocar o flavor troca **todos** esses de uma vez, de forma coerente.

---

## 3. Intake — o que perguntar / pedir pra montar um flavor

Pra derivar um DS novo, colher (nesta ordem de prioridade):

### 3.1 Marca e identidade (obrigatório)
- **Logo** (SVG) + **cor primária** (hex) + paleta de marca (prints/links do
  brand book, Figma, ou site).
- **Cores semânticas** já existem? (erro/sucesso/aviso) — ou derivamos da
  primária?
- **Fonte** da marca (arquivo .ttf/.otf ou nome + link). Sem fonte própria →
  cai num default legível.

### 3.2 Personalidade visual (guiado por perguntas)
Perguntas fechadas que mapeiam pra tokens (evita "achismo"):

1. **Cantos:** retos, levemente arredondados, ou bem arredondados/pílula?
   → escala de radius.
2. **Profundidade:** flat (sem sombra), sutil, ou com bastante sombra/camadas?
   → receitas de elevation.
3. **Voz da tipografia:** técnica/neutra, humana/arredondada, ou editorial/serif?
   → família + pesos.
4. **Movimento:** discreto e rápido, ou expressivo e fluido? → tokens de motion.
5. **Densidade:** espaçado (respiro) ou compacto (mais info por tela)?
   → spacing base / densidade.
6. **Acabamento:** sólido/chapado ou com gradiente/brilho? → gradientes.

### 3.3 Referências (prints / links — muito úteis)
Pedir:
- 3-5 **telas de referência** (prints ou links) do produto/marca alvo, ou de
  apps que representem o feel desejado.
- Link do **Figma** (se houver Variables → alimenta o pipeline DTCG direto, V2).
- Brand book / style guide (PDF ou link).

Cada referência vira uma leitura de: paleta, raio dominante, sombra, fonte,
ritmo de espaçamento. É o que traduz "quero algo mais sério/mais fintech/mais
divertido" em valores de token concretos.

### 3.4 Escopo
- É **rebrand total** (nova marca) ou **sub-marca/cobrand** (só acento)?
- Multiplataforma? (mobile + web → os tokens gerados servem os dois)

---

## 4. Do intake ao flavor (fluxo)

1. Preencher o **questionário** (§3) — respostas + prints/links.
2. Traduzir respostas → `tokens/flavors/<marca>.tokens.json` (primitivos +
   roles + type + radius + elevation + motion).
3. `dart run cpf_seguro_ds:new-flavor <marca>` scaffolda o arquivo + registra
   `CpfSeguroPalette.<marca>`.
4. `npm run tokens` (Style Dictionary) gera Dart + CSS do flavor.
5. Abrir o **catálogo com o flavor** (`?flavor=<marca>`) — revisão visual de
   TODOS os componentes na nova pele de uma vez. É aqui que se valida coerência.
6. Ajustar tokens onde a referência pedir; repetir 4-5.
7. Rodar o gate de **contraste** (V4, `roles_contrast_test`) — todo par
   role/on-role tem que passar WCAG AA na nova paleta. Falhou → não fecha.

---

## 5. O questionário como artefato

O §3 vira um **form** (JSON/markdown) que o intake preenche. Estrutura:

```json
{
  "marca": "Nome",
  "logoSvg": "<path/link>",
  "primaria": "#XXXXXX",
  "semanticas": { "erro": null, "sucesso": null },
  "fonte": { "nome": "...", "arquivo": "<link>" },
  "personalidade": {
    "cantos": "arredondado",
    "profundidade": "sutil",
    "voz": "humana",
    "movimento": "fluido",
    "densidade": "espacado",
    "acabamento": "gradiente"
  },
  "referencias": ["<print/link>", "..."],
  "figmaVariables": "<link ou null>",
  "escopo": "rebrand-total"
}
```

Esse JSON é o INPUT do gerador de flavor. Fecha o ciclo: intake estruturado →
token flavor → catálogo re-skinado → validação de contraste.

---

## 6. Garantias

- **Um dono do token:** se vier do Figma (Variables), a direção canônica é
  Figma → código (V2). Sem dois donos.
- **Contraste no CI** por flavor (V4) — pele nova não pode quebrar a11y.
- **Anatomia intacta:** o mesmo catálogo, os mesmos contratos, provam que o
  flavor não forkou nada. Se forkou, saiu do escopo de flavor.
