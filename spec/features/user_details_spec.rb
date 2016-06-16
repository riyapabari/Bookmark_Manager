feature 'User details' do

	scenario 'when user signs up, user count increases by 1' do
		expect{sign_up}.to change(User, :count).by(1)
	end

	scenario 'page displays welcome message to new user' do
		sign_up
		expect(page).to have_content("Welcome, riya.pabari@gmail.com!")
	end

	scenario 'email address for user is correct' do
		sign_up
		expect(User.first.email).to eq('riya.pabari@gmail.com')
	end

	feature 'Password confirmation' do

		scenario 'no new user created when pw is mismatched' do
			expect{ sign_up_pw_mismatch }.not_to change(User, :count)
		end

		scenario 'new user created when pw and confirm matches' do
			expect{ sign_up }.to change(User, :count).by(1)
		end

		scenario "displays error when passwords don't match" do
			sign_up_pw_mismatch
			expect(current_path).to eq '/users/sign_up'
		  message = 'Password and confirmation password do not match'
			expect(page).to have_content message
		end

		scenario "email is persisted after password mismatch" do
			sign_up_pw_mismatch
			expect(page).to have_selector("input[value='riya.pabari@gmail.com']")
		end

	end

end