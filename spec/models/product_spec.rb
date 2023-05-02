require 'rails_helper'

RSpec.describe Product, type: :model do

  describe '#valido?' do
    it 'inválido quando nome fica em branco' do
      #Arrange
      product = Product.new(name: '', weight: 8000, width: 70, height: 45, depth: 10,
                          category: 'categoria', description: 'descrição')
      #Assert
      expect(product).not_to be_valid
      expect(product.errors[:name]).to include('não pode ficar em branco')
    end

    it 'inválido quando peso fica em branco' do
      #Arrange
      product = Product.new(name: 'Produto', weight: nil, width: 70, height: 45, depth: 10,
                          category: 'categoria', description: 'descrição')
      #Assert
      expect(product).not_to be_valid
      expect(product.errors[:weight]).to include('não pode ficar em branco')
    end

    it 'inválido quando largura fica em branco' do
      #Arrange
      product = Product.new(name: 'Produto', weight: 8000 , width: nil, height: 45, depth: 10,
                          category: 'categoria', description: 'descrição')
      #Assert
      expect(product).not_to be_valid
      expect(product.errors[:width]).to include('não pode ficar em branco')
    end

    it 'inválido quando altura fica em branco' do
      #Arrange
      product = Product.new(name: 'Produto', weight: 8000 , width: 70, height: nil, depth: 10,
                          category: 'categoria', description: 'descrição')
      #Assert
      expect(product).not_to be_valid
      expect(product.errors[:height]).to include('não pode ficar em branco')
    end

    it 'inválido quando profundidade fica em branco' do
      #Arrange
      product = Product.new(name: 'Produto', weight: 8000 , width: 70, height: 45, depth: nil,
                          category: 'categoria', description: 'descrição')
      #Assert
      expect(product).not_to be_valid
      expect(product.errors[:depth]).to include('não pode ficar em branco')
    end

    it 'inválido quando categoria fica em branco' do
      #Arrange
      product = Product.new(name: 'Produto', weight: 8000 , width: 70, height: 45, depth: 10,
                          category: '', description: 'descrição')
      #Assert
      expect(product).not_to be_valid
      expect(product.errors[:category]).to include('não pode ficar em branco')
    end

    it 'inválido quando descrição fica em branco' do
      #Arrange
      product = Product.new(name: 'Produto', weight: 8000 , width: 70, height: 45, depth: 10,
                          category: 'categoria', description: '')
      #Assert
      expect(product).not_to be_valid
      expect(product.errors[:description]).to include('não pode ficar em branco')
    end

    it 'inválido quando peso não é um número' do
      #Arrange
      product = Product.new(name: 'Produto', weight: 'abc', width: 70, height: 45, depth: 10,
                          category: 'categoria', description: 'descrição')
      #Assert
      expect(product).not_to be_valid
      expect(product.errors[:weight]).to include('não é um número')
    end

    it 'inválido quando largura não é um número' do
      #Arrange
      product = Product.new(name: 'Produto', weight: 8000, width: 'abc', height: 45, depth: 10,
                          category: 'categoria', description: 'descrição')
      #Assert
      expect(product).not_to be_valid
      expect(product.errors[:width]).to include('não é um número')
    end

    it 'inválido quando altura não é um número' do
      #Arrange
      product = Product.new(name: 'Produto', weight: 'abc' , width: 70, height: 'abc', depth: 10,
                          category: 'categoria', description: 'descrição')
      #Assert
      expect(product).not_to be_valid
      expect(product.errors[:height]).to include('não é um número')
    end

    it 'inválido quando profundidade não é um número' do
      #Arrange
      product = Product.new(name: 'Produto', weight: 8000, width: 70, height: 45, depth: 'abc',
                          category: 'categoria', description: 'descrição')
      #Assert
      expect(product).not_to be_valid
      expect(product.errors[:depth]).to include('não é um número')
    end

    it 'válido quando identificador é gerado automaticamente e tem 10 carácteres' do
      #Arrange
      product = Product.create!(name: 'Produto', weight: 8000, width: 70, height: 45, depth: 10,
                          category: 'categoria', description: 'descrição')
      #Assert
      expect(product.identifier).not_to be_nil
      expect(product.identifier.length).to eq 10
    end

    it 'inválido quando identificador já existe' do
      # Arrange
      allow(SecureRandom).to receive(:alphanumeric).and_return('ABCDE12345')

      product = Product.create!(name: 'Produto', weight: 8000, width: 70, height: 45, depth: 10,
                                category: 'categoria', description: 'descrição')
      second_product = Product.new(name: 'Produto', weight: 8000, width: 70, height: 45, depth: 10,
                                   category: 'categoria', description: 'descrição')

      #Assert
      expect(product.identifier).to eq('ABCDE12345')
      expect(second_product).not_to be_valid
      expect(second_product.errors[:identifier]).to include('já está em uso')
    end

    it 'inválido quando identificador é maior de 10' do
      #Arrange
      allow(SecureRandom).to receive(:alphanumeric).and_return('ABCDE123456')

      product = Product.new(name: 'Produto', weight: 8000, width: 70, height: 45, depth: 10,
                category: 'categoria', description: 'descrição')
      #Assert
      expect(product).not_to be_valid
      expect(product.errors[:identifier]).to include('não possui o tamanho esperado (10 caracteres)')
    end

    it 'inválido quando identificador é menor de 10' do
      #Arrange
      allow(SecureRandom).to receive(:alphanumeric).and_return('ABCDE1234')

      product = Product.new(name: 'Produto', weight: 8000, width: 70, height: 45, depth: 10,
                category: 'categoria', description: 'descrição')
      #Assert
      expect(product).not_to be_valid
      expect(product.errors[:identifier]).to include('não possui o tamanho esperado (10 caracteres)')
    end
  end
end
