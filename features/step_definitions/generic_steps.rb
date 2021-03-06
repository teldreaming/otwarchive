When /^(?:|I )unselect "([^"]+)" from "([^"]+)"$/ do |item, selector|
  unselect(item, :from => selector)
end

Then /^debug$/ do
  breakpoint
  0
end

Then /^show me the response$/ do
  puts page.body
end

Then /^show me the main content$/ do
  puts "\n" + find("#main").node.inner_html
end

Given /^I wait (\d+) seconds?$/ do |number|
  Kernel::sleep number.to_i
end

When 'the system processes jobs' do
  #resque runs inline during testing. see resque.rb in initializers/gem-plugin_config
  #Delayed::Worker.new.work_off
end

When 'I reload the page' do
  visit current_url
end

Then /^I should see Posted now$/ do
	now = Time.zone.now.to_s
  Given "I should see \"Posted #{now}\""
end

When /^I fill in "([^\"]*)" with$/ do |field, value|
  fill_in(field, :with => value)
end

When /^I fill in "([^\"]*)" with `([^\`]*)`$/ do |field, value|
  fill_in(field, :with => value)
end

When /^I fill in "([^\"]*)" with '([^\']*)'$/ do |field, value|
  fill_in(field, :with => value)
end

Then /^I should find "([^"]*)"(?: within "([^"]*)")?$/ do |text, selector|
  with_scope(selector) do
    page.find(text)
  end
end

Then /^I should find '([^']*)'(?: within "([^"]*)")?$/ do |text, selector|
  with_scope(selector) do
    page.find(text)
  end
end

Then /^I should not find "([^"]*)"(?: within "([^"]*)")?$/ do |text, selector|
  with_scope(selector) do
    begin
      wait_until do
        page.find(text)
      end
    rescue Capybara::TimeoutError
    end
  end
end

Then /^I should see the "(alt|title)" text "([^\"]*)"(?: within "([^"]*)")?$/ do |texttype, text, selector|
  with_scope(selector) do
    (texttype == "alt") ? (page.should have_xpath("//img[@alt='#{text}']")) : (page.should have_xpath("//img[@title='#{text}']"))
  end
end

Then /^I should not see the "(alt|title)" text "([^\"]*)"(?: within "([^"]*)")?$/ do |texttype, text, selector|
  with_scope(selector) do
    (texttype == "alt") ? (page.should have_no_xpath("//img[@alt='#{text}']")) : (page.should have_no_xpath("//img[@title='#{text}']"))
  end
end

Then /^"([^"]*)" should be selected within "([^"]*)"$/ do |value, field|
  find_field(field).node.xpath(".//option[@selected = 'selected']").inner_html.should =~ /#{value}/
end

Then /^I should see "([^"]*)" in the "([^"]*)" input/ do |content, labeltext|
  find_field("#{labeltext}").value.should == content
end

When /^"([^\"]*)" is fixed$/ do |what|
  puts "\nDEFERRED (#{what})"
end

Then /^the "([^"]*)" checkbox(?: within "([^"]*)")? should be disabled$/ do |label, selector|
  with_scope(selector) do
    field_disabled = find_field(label)['disabled']
    if field_disabled.respond_to? :should
      field_disabled.should be_true
    else
      assert field_disabled
    end
  end
end

Then /^the "([^"]*)" checkbox(?: within "([^"]*)")? should not be disabled$/ do |label, selector|
  with_scope(selector) do
    field_disabled = find_field(label)['disabled']
    if field_disabled.respond_to? :should
      field_disabled.should be_false
    else
      assert !field_disabled
    end
  end
end

Then /^I should find "([^"]*)" selected within "([^"]*)"$/ do |text, selector|
    if page.respond_to? :should
      page.should have_content('<option selected="selected" value="' + text + '"')
    else
      assert page.has_content?('<option selected="selected" value="' + text + '"')
    end
end


When /^I check the (\d+)(st|nd|rd|th) checkbox with the value "([^"]*)"$/ do |index, junk, value|
  check(page.all("input[type='checkbox']").select {|el| el.node['value'] == value}[(index.to_i-1)].node['id'])
end

When /^I check the (\d+)(st|nd|rd|th) checkbox with value "([^"]*)"$/ do |index, junk, value|
  When %{I check the #{index}#{junk} checkbox with the value "#{value}"}
end

When /^I uncheck the (\d+)(st|nd|rd|th) checkbox with the value "([^"]*)"$/ do |index, junk, value|
  uncheck(page.all("input[type='checkbox']").select {|el| el.node['value'] == value}[(index.to_i-1)].node['id'])
end

When /^I check the (\d+)(st|nd|rd|th) checkbox with id matching "([^"]*)"$/ do |index, junk, id_string|
  check(page.all("input[type='checkbox']").select {|el| el.node['id'] && el.node['id'].match(/#{id_string}/)}[(index.to_i-1)].node['id'])
end

When /^I fill in the (\d+)(st|nd|rd|th) field with id matching "([^"]*)" with "([^"]*)"$/ do |index, junk, id_string, value|
  fill_in(page.all("input[type='text']").select {|el| el.node['id'] && el.node['id'].match(/#{id_string}/)}[(index.to_i-1)].node['id'], :with => value)
end

When /^I submit$/ do
  %{When I press "Submit"}
end

# we want greedy matching for this one so we can handle tags that have attributes in them
Then /^I should see the text with tags "(.*)"$/ do |text|
  page.body.should =~ /#{text}/m
end

Then /^I should see the text with tags '(.*)'$/ do |text|
  page.body.should =~ /#{text}/m
end

Then /^I should see the page title "(.*)"$/ do |text|
  within('head title') do
    page.should have_content(text)
  end
end

Given /^I have no prompts$/ do
  Prompt.delete_all
end
