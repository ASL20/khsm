# Как и в любом тесте, подключаем помощник rspec-rails
require 'rails_helper'

# Начинаем описывать функционал, связанный с созданием игры
RSpec.feature 'USER sees another profile', type: :feature do
  # Чтобы пользователь мог начать игру, нам надо
  # создать пользователя
  let(:user1) { FactoryBot.create :user, name: 'user1', id: 1}
  let!(:user2) { FactoryBot.create :user, name: 'user2', id: 2}

  let!(:games) {[
    FactoryBot.create(
      :game,
      id: 1,
      user_id: 2,
      created_at: Time.parse('2021.03.27, 12:30'),
      finished_at: Time.parse('2021.03.27, 13:00'),
      current_level: 16,
      prize: 1000000
    ),
    FactoryBot.create(
      :game,
      id: 2,
      user_id: 2,
      created_at: Time.parse('2021.03.31, 13:30'),
      finished_at: Time.parse('2021.03.31, 14:30'),
      is_failed: true,
      current_level: 10
    )
  ]}

  # Перед началом любого сценария нам надо авторизовать пользователя
  before(:each) do
    login_as user1
  end

  # Сценарий просмотра чужого профиля
  scenario 'view another profile' do
    # Заходим в профиль другого игрока
    visit '/users/2'

    # проверяем первую игру
    expect(page).to have_content '1'
    expect(page).to have_content 'победа'
    expect(page).to have_content '27 марта, 12:30'
    expect(page).to have_content '16'
    expect(page).to have_content '1 000 000 ₽'
    expect(page).to have_content '50/50'


    # проверяем вторую игру
    expect(page).to have_content '2'
    expect(page).to have_content 'время'
    expect(page).to have_content '31 марта, 13:30'
    expect(page).to have_content '10'
    expect(page).to have_content '0 ₽'
    expect(page).to have_content '50/50'

    # проверяем, что текущий пользователь не видит кнопку
    # смены пароля у другого пользователя
    expect(page).not_to match 'Сменить имя и пароль'
  end
end
