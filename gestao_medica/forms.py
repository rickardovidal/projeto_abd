from django import forms

class MedicamentoForm(forms.Form):
   
    nome = forms.CharField(
        label='Nome',
        max_length=100,
        widget=forms.TextInput(attrs={
            'placeholder': 'Nome do Medicamento',
            'class': 'form-control'
        })
    )
    observacoes = forms.CharField(
        label='Observacoes',
        widget=forms.TextInput(attrs={
            'placeholder': 'Observacoes',
            'class': 'form-control'
        })
    )

class CondicoesForm(forms.Form):
   
    nome = forms.CharField(
        label='Nome',
        max_length=100,
        widget=forms.TextInput(attrs={
            'placeholder': 'Nome da Condicao Médica',
            'class': 'form-control'
        })
    )
    observacoes = forms.CharField(
        label='Observacoes',
        widget=forms.TextInput(attrs={
            'placeholder': 'Observacoes',
            'class': 'form-control'
        })
    )
    estado = forms.BooleanField(
        label='Estado',
        required=False,
        widget=forms.CheckboxInput(attrs={
            'class': 'form-check-input'
        })
    )

