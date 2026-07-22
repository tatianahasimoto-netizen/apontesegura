## Purpose

Contrato do **`CpfSeguroReceipt`** — o comprovante de uma transação (compra no
cartão, Pix aproximação): cabeçalho + linhas label/valor (`CpfSeguroDetailRow`) +
marca CPF.

## Requirements

### Requirement: Linhas via DetailRow
As linhas label/valor do comprovante SHALL ser `CpfSeguroDetailRow`, não linhas
montadas na mão.

#### Scenario: Comprovante Pix
- **WHEN** o comprovante lista origem/bandeira/id
- **THEN** cada linha é um DetailRow

### Requirement: Marca CPF no comprovante
`CpfSeguroReceipt` SHALL trazer a marca CPF Seguro (instituição de pagamento) no
comprovante.

#### Scenario: Rodapé do comprovante
- **WHEN** o comprovante é exibido
- **THEN** mostra a marca CPF Seguro

### Requirement: Comprovante, não card genérico
`CpfSeguroReceipt` SHALL ser o comprovante de transação. Bloco informativo comum
SHALL usar `CpfSeguroInfoCard`.

#### Scenario: Aviso informativo
- **WHEN** é um card de informação comum
- **THEN** é InfoCard, não Receipt
