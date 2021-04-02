require 'rails_helper'

# Тест на шаблон users/show.html.erb

RSpec.describe 'users/show', type: :view do
  # Перед каждым шагом мы пропишем в переменную @users пару пользователей
  # как бы имитируя действие контроллера, который эти данные будет брать из базы
  # Обратите внимание, что мы объекты в базу не кладем, т.к. пишем FactoryBot.build_stubbed
  context 'Anon user' do
    before(:each) do
      assign(:user, FactoryBot.build_stubbed(:user, name: 'Пользователь', balance: 3000, id: 1))
      assign(:games, [FactoryBot.build_stubbed(:game, id: 10, created_at: Time.now, current_level: 10, prize: 1000, user_id: 1)])
      render
    end

    # Проверяем, что шаблон выводит имена игроков
    it 'renders user name ' do
      expect(rendered).to match 'Пользователь'
    end

    # Проверяем, что шаблон выводит балансы игроков
    it 'not renders button of change password' do
      expect(rendered).not_to match 'Сменить имя и пароль'
    end

    it 'renders fragments with game' do
      assert_template partial: 'users/_game'
    end
  end

  context 'Current user' do
    before(:each) do
      user = FactoryBot.build_stubbed(:user, name: 'Пользователь', balance: 3000, email: 'user1@user.ru')
      sign_in user

      assign(:user, user)
      assign(:games, [FactoryBot.build_stubbed(:game, id: 10, created_at: Time.now, current_level: 10)])
      render
    end

    # Проверяем, что шаблон выводит имена игроков
    it 'renders user name ' do
      expect(rendered).to match 'Пользователь'
    end

    # Проверяем, что шаблон выводит балансы игроков
    it 'renders button of change password' do
      expect(rendered).to match 'Сменить имя и пароль'
    end

    it 'renders fragments with game' do
      assert_template partial: 'users/_game'
    end
  end
end
