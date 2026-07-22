# CPF Seguro DS — Adoção em um projeto novo

> O mínimo que um projeto precisa pra consumir o DS, e o alvo: reduzir esse
> mínimo a um comando. Camada de execução; fundação em [`DS_LANGUAGE.md`](./DS_LANGUAGE.md).

Status: proposta (v0). Documento vivo.

---

## 1. O que o package já entrega

O package `cpf_seguro_design_system` **já embarca**:

- **Fonte** (`SF Pro Rounded`) via `packages/cpf_seguro_design_system/...` — o
  consumidor não precisa redeclarar (o app CPF ainda redeclara `SFProRounded`
  por legado; projeto novo NÃO precisa).
- **Assets** (ícones `.vec`, ilustrações) resolvidos por
  `CpfSeguroAssets.assetPackage` (`AssetBytesLoader(packageName:)`).
- **Tokens** (cor/roles/raio/spacing/elevação/gradiente/tipografia/motion)
  gerados do DTCG.
- **Tema** por flavor (`CpfSeguroScheme.light(CpfSeguroPalette.cpf)`).

Ou seja: o significado, a fonte e os assets viajam DENTRO do package. O
consumidor só precisa **ligar** três coisas: dependência, tema e assetPackage.

---

## 2. Mínimo HOJE (manual)

```yaml
# pubspec.yaml
dependencies:
  cpf_seguro_design_system:
    git: { url: <repo>, ref: v0.34.0 }   # ou pub server privado
```

```dart
// main.dart
import 'package:cpf_seguro_design_system/cpf_seguro_design_system.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // 1. Assets do DS (ícones/ilustrações) resolvem pelo package.
  CpfSeguroAssets.assetPackage = CpfSeguroAssets.package;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 2. Escopo do tema (flavor) — dá o scheme pros componentes.
    return CpfSeguroThemeScope(
      theme: CpfSeguroTheme.cpfLight,
      child: MaterialApp(
        // 3. ThemeData que injeta a família e o fg do scheme no textTheme.
        theme: cpfSeguroThemeData(CpfSeguroScheme.light(CpfSeguroPalette.cpf)),
        home: const HomeScreen(),
      ),
    );
  }
}
```

**Três ligações:** `assetPackage` · `CpfSeguroThemeScope` · `ThemeData`. É isso
pra ter todos os componentes (`Button`, `Input`, `AppList`, `Nav`, glass chrome…).

### Gap atual (a resolver pra o mínimo ser mesmo mínimo)
O passo 3 hoje mora no APP (`buildAppTheme` é do `cpf-seguro-real`, não do
package). Pra adoção limpa, o **DS precisa exportar** um builder de tema:

```dart
// alvo — o DS passa a exportar isto:
ThemeData cpfSeguroThemeData(CpfSeguroScheme scheme);
```

Enquanto não existe, o projeto novo copia o `buildAppTheme` (~20 linhas). É a
primeira tarefa desta trilha: **subir o theme-builder pro package**.

---

## 3. Alvo — bootstrap em um widget

O ideal é o DS entregar um wrapper que faz as três ligações:

```dart
void main() => runApp(
  CpfSeguroApp(
    flavor: CpfSeguroPalette.cpf,   // qual DS/marca
    home: HomeScreen(),
  ),
);
```

`CpfSeguroApp` faz internamente: `assetPackage`, `ThemeScope`, `MaterialApp` +
`ThemeData` do flavor, e (opcional) `EasyLocalization` se o projeto usar. O
consumidor não toca em nenhum token cru.

---

## 4. Starter / CLI

Pra zerar o atrito de projeto novo:

```
dart run cpf_seguro_ds:init
```

Scaffolda:
- dependência no `pubspec` (ref/pub);
- `main.dart` com `CpfSeguroApp`;
- uma tela de exemplo (Surface top/content/bottom com Button);
- `analysis_options` com a regra de lint "sem cor/raio/spacing cru"
  (reforça o contrato — ver [`DS_LANGUAGE.md`](./DS_LANGUAGE.md) §2).

`dart run cpf_seguro_ds:doctor` valida um projeto existente (assetPackage
ligado? tema via flavor? algum literal cru de token?).

---

## 5. Checklist de adoção (o "mínimo")

- [ ] dependência do package (ref/pub)
- [ ] `CpfSeguroAssets.assetPackage` setado no `main`
- [ ] `CpfSeguroThemeScope` + `ThemeData` do flavor no topo
- [ ] (nada de fonte/assets próprios — vêm do package)
- [ ] lint "sem token cru" ligado (opcional, recomendado)

Tudo isso deve caber num `CpfSeguroApp` + no `init`. O norte é: **adotar = um
comando + um widget.**

---

## 6. Trilha de trabalho

1. Subir `cpfSeguroThemeData(scheme)` e `CpfSeguroApp` pro package (tira o
   bootstrap do app).
2. Escrever o CLI `init` + `doctor`.
3. `ONBOARDING.md` gerável + link compartilhável pro time.
4. Regra de lint publicável (custom_lint) de "sem token cru".
