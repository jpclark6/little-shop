require 'rails_helper'

describe 'as a visitor' do
  describe 'on the navbar' do
    it 'sees links in the navbar' do
      visit root_path

      within "nav" do
        expect(page).to have_link("Home", href: "/")
        expect(page).to have_link("Browse", href: "/items" )
        expect(page).to have_link("Merchants", href: "/merchants")
        expect(page).to have_link("Cart", href: "/cart")
        expect(page).to have_link("Log in", href: "/login")
        expect(page).to have_link("Register", href: "/register")
      end
    end
    xit "sees count of cart items" do 
      #add code here
    end
  end
end
