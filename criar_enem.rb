def read_file(path)
  file = File.open(path, 'r')
  text = file.read
  file.close
  text
end

def write_file(path, text)
  file = File.open(path, 'w')
  file.write text
  file.close
end

puts 'Você está prestes a criar um novo ano de ENEM no aplicativo, só poderá reverter isso através do git'

puts 'Digite o ano do enem que deseja criar: '
year = gets.chomp

puts 'Esse ano já foi criado anteriormente? (y/n)'
created_year = gets.chomp
while(created_year.downcase != 'y' && created_year.downcase != 'n')
  puts 'Resposta inválida.'
  puts 'Esse ano já foi criado anteriormente? (y/n)'
  created_year = gets.chomp
end

puts 'Digite a edição do enem que deseja criar: '
edition = gets.chomp

puts 'Digite o link da primeira prova: '
link_prova_um = gets.chomp.sub(/\/view.*/, '/preview').sub(/\?.*/, '')

puts 'Existe uma segunda prova? (y/n)'
prova_dois = gets.chomp
while(prova_dois.downcase != 'y' && prova_dois.downcase != 'n')
  puts 'Resposta inválida.'
  puts 'Existe uma segunda prova? (y/n)'
  prova_dois = gets.chomp
end

if prova_dois.downcase == 'y'
  puts 'Digite o link da segunda prova: '
  link_prova_dois = gets.chomp.sub(/\/view.*/, '/preview').sub(/\?.*/, '')
end

puts 'Digite o link do primeiro gabarito: '
link_gabarito_um = gets.chomp.sub(/\/view.*/, '/preview').sub(/\?.*/, '')

if prova_dois.downcase == 'y'
  puts 'Digite o link do segundo gabarito: '
  link_gabarito_dois = gets.chomp.sub(/\/view.*/, '/preview').sub(/\?.*/, '')
end

content = '<div class="row" style="max-width: 100% !important; margin-left: 0px !important; margin-right: 0px !important; padding-bottom: 67px !important;">'
footer = '<footer class="text-center w-100 bg-black" style="position: fixed; bottom: 0;">'
back_button = "#{footer}\n    <a href=\"LINK\" class=\"btn btn-lg btn-outline-dark btn-light p-2 w-100 mb-2\" style=\"min-width: 100%; white-space: nowrap;\"><i class=\"fas fa-arrow-left\"></i> Voltar</a>"

if created_year.downcase == 'n'
  # edita a página years/index.html para criar o botão do ano do enem
  file_text = read_file('years/index.html')
  text_to_add = "#{content}\n      <div class=\"col-6 mt-3 mb-3 text-center\">\n        <a href=\"#{year}/index.html\" class=\"btn btn-lg btn-outline-dark btn-light p-2\" style=\"min-width: 90%; white-space: nowrap;\">#{year}</a>\n      </div>"
  file_text.sub!(content, text_to_add)
  write_file('years/index.html', file_text)

  # cria a pasta do ano
  Dir.mkdir("years/#{year}")

  # cria a página do ano do enem
  file_text = read_file('layout/years_show.html')
  text_to_add = "#{content}\n      <div class=\"col-12 mt-3 mb-3 text-center\">\n        <a href=\"#{edition.gsub(/[^0-9A-Za-z]/, '')}/index.html\" class=\"btn btn-lg btn-outline-dark btn-light p-2\" style=\"min-width: 90%; white-space: nowrap;\">#{edition}</a>\n      </div>"
  file_text.sub!(content, text_to_add)
  file_text.sub!(footer, back_button.sub('LINK', '../index.html'))
  write_file("years/#{year}/index.html", file_text)
else
  # edita a página do ano do enem
  file_text = read_file("years/#{year}/index.html")
  text_to_add = "#{content}\n      <div class=\"col-12 mt-3 mb-3 text-center\">\n        <a href=\"#{edition.gsub(/[^0-9A-Za-z]/, '')}/index.html\" class=\"btn btn-lg btn-outline-dark btn-light p-2\" style=\"min-width: 90%; white-space: nowrap;\">#{edition}</a>\n      </div>"
  file_text.sub!(content, text_to_add)
  write_file("years/#{year}/index.html", file_text)
end

# cria a pasta da edição
Dir.mkdir("years/#{year}/#{edition.gsub(/[^0-9A-Za-z]/, '')}")

# cria a página da edição do enem
file_text = read_file('layout/enems_index.html')
text_to_add = "#{content}\n      <div class=\"col-6 mt-3 mb-3 text-center\">\n        <a href=\"provas/index.html\" class=\"btn btn-lg btn-outline-dark btn-light p-2\" style=\"min-width: 90%; white-space: nowrap;\">PROVAS</a>\n      </div>\n      <div class=\"col-6 mt-3 mb-3 text-center\">\n        <a href=\"gabaritos/index.html\" class=\"btn btn-lg btn-outline-dark btn-light p-2\" style=\"min-width: 90%; white-space: nowrap;\">GABARITOS</a>\n      </div>"
file_text.sub!(content, text_to_add)
file_text.sub!(footer, back_button.sub('LINK', '../index.html'))
write_file("years/#{year}/#{edition.gsub(/[^0-9A-Za-z]/, '')}/index.html", file_text)

# cria a pasta das provas da edição
Dir.mkdir("years/#{year}/#{edition.gsub(/[^0-9A-Za-z]/, '')}/provas")
Dir.mkdir("years/#{year}/#{edition.gsub(/[^0-9A-Za-z]/, '')}/provas/1")
Dir.mkdir("years/#{year}/#{edition.gsub(/[^0-9A-Za-z]/, '')}/provas/2") if prova_dois.downcase == 'y'

# cria a pasta dos gabaritos da edição
Dir.mkdir("years/#{year}/#{edition.gsub(/[^0-9A-Za-z]/, '')}/gabaritos")
Dir.mkdir("years/#{year}/#{edition.gsub(/[^0-9A-Za-z]/, '')}/gabaritos/1")
Dir.mkdir("years/#{year}/#{edition.gsub(/[^0-9A-Za-z]/, '')}/gabaritos/2") if prova_dois.downcase == 'y'

if prova_dois.downcase == 'y'
  # cria a página de provas da edição
  file_text = read_file('layout/enems_show.html')
  text_to_add = "#{content}\n      <div class=\"col-6 mt-3 mb-3 text-center\">\n        <form class=\"button_to\" method=\"get\" action=\"1/index.html\">\n          <button class=\"btn btn-lg btn-outline-dark btn-light btn-download p-2 mb-2\" style=\"min-width: 90%;\" type=\"submit\">\n            <span style=\"font-size: 1rem; white-space: nowrap;\">PROVA 1º DIA</span>\n          </button>\n        </form>\n      </div>\n      <div class=\"col-6 mt-3 mb-3 text-center\">\n        <form class=\"button_to\" method=\"get\" action=\"2/index.html\">\n          <button class=\"btn btn-lg btn-outline-dark btn-light btn-download p-2 mb-2\" style=\"min-width: 90%;\" type=\"submit\">\n            <span style=\"font-size: 1rem; white-space: nowrap;\">PROVA 2º DIA</span>\n          </button>\n        </form>\n      </div>"
  file_text.sub!(content, text_to_add)
  file_text.sub!(footer, back_button.sub('LINK', '../index.html'))
  write_file("years/#{year}/#{edition.gsub(/[^0-9A-Za-z]/, '')}/provas/index.html", file_text)

  # cria a página de gabaritos da edição
  file_text = read_file('layout/enems_show.html')
  text_to_add = "#{content}\n      <div class=\"col-6 mt-3 mb-3 text-center\">\n        <form class=\"button_to\" method=\"get\" action=\"1/index.html\">\n          <button class=\"btn btn-lg btn-outline-dark btn-light btn-download p-2 mb-2\" style=\"min-width: 90%;\" type=\"submit\">\n            <span style=\"font-size: 1rem; white-space: nowrap;\">GABARITO 1º DIA</span>\n          </button>\n        </form>\n      </div>\n      <div class=\"col-6 mt-3 mb-3 text-center\">\n        <form class=\"button_to\" method=\"get\" action=\"2/index.html\">\n          <button class=\"btn btn-lg btn-outline-dark btn-light btn-download p-2 mb-2\" style=\"min-width: 90%;\" type=\"submit\">\n            <span style=\"font-size: 1rem; white-space: nowrap;\">GABARITO 2º DIA</span>\n          </button>\n        </form>\n      </div>"
  file_text.sub!(content, text_to_add)
  file_text.sub!(footer, back_button.sub('LINK', '../index.html'))
  write_file("years/#{year}/#{edition.gsub(/[^0-9A-Za-z]/, '')}/gabaritos/index.html", file_text)
else
  # cria a página de provas da edição
  file_text = read_file('layout/enems_show.html')
  text_to_add = "#{content}\n      <div class=\"col-6 mt-3 mb-3 text-center\">\n        <form class=\"button_to\" method=\"get\" action=\"1/index.html\">\n          <button class=\"btn btn-lg btn-outline-dark btn-light btn-download p-2 mb-2\" style=\"min-width: 90%;\" type=\"submit\">\n            <span style=\"font-size: 1rem; white-space: nowrap;\">PROVA 1º DIA</span>\n          </button>\n        </form>\n      </div>"
  file_text.sub!(content, text_to_add)
  file_text.sub!(footer, back_button.sub('LINK', '../index.html'))
  write_file("years/#{year}/#{edition.gsub(/[^0-9A-Za-z]/, '')}/provas/index.html", file_text)

  # cria a página de gabaritos da edição
  file_text = read_file('layout/enems_show.html')
  text_to_add = "#{content}\n      <div class=\"col-6 mt-3 mb-3 text-center\">\n        <form class=\"button_to\" method=\"get\" action=\"1/index.html\">\n          <button class=\"btn btn-lg btn-outline-dark btn-light btn-download p-2 mb-2\" style=\"min-width: 90%;\" type=\"submit\">\n            <span style=\"font-size: 1rem; white-space: nowrap;\">GABARITO 1º DIA</span>\n          </button>\n        </form>\n      </div>"
  file_text.sub!(content, text_to_add)
  file_text.sub!(footer, back_button.sub('LINK', '../index.html'))
  write_file("years/#{year}/#{edition.gsub(/[^0-9A-Za-z]/, '')}/gabaritos/index.html", file_text)
end

content_tests_show = "<div class=\"w-100 h-100\" style=\"max-width: 100% !important; margin-left: 0px !important; margin-right: 0px !important; padding-bottom: 57px !important;\">"

# cria a página para visualizar a prova 1
file_text = read_file('layout/tests_show.html')
text_to_add = "#{content_tests_show}\n      <iframe src=\"#{link_prova_um}\" style=\"height: 100%; width: 100%;\"></iframe>"
file_text.sub!(content, text_to_add)
file_text.sub!(footer, back_button.sub('LINK', '../index.html'))
write_file("years/#{year}/#{edition.gsub(/[^0-9A-Za-z]/, '')}/provas/1/index.html", file_text)

if prova_dois.downcase == 'y'
  # cria a página para visualizar a prova 2
  file_text = read_file('layout/tests_show.html')
  text_to_add = "#{content_tests_show}\n      <iframe src=\"#{link_prova_dois}\" style=\"height: 100%; width: 100%;\"></iframe>"
  file_text.sub!(content, text_to_add)
  file_text.sub!(footer, back_button.sub('LINK', '../index.html'))
  write_file("years/#{year}/#{edition.gsub(/[^0-9A-Za-z]/, '')}/provas/2/index.html", file_text)
end

# cria a página para visualizar o gabarito 1
file_text = read_file('layout/tests_show.html')
text_to_add = "#{content_tests_show}\n      <iframe src=\"#{link_gabarito_um}\" style=\"height: 100%; width: 100%;\"></iframe>"
file_text.sub!(content, text_to_add)
file_text.sub!(footer, back_button.sub('LINK', '../index.html'))
write_file("years/#{year}/#{edition.gsub(/[^0-9A-Za-z]/, '')}/gabaritos/1/index.html", file_text)

if prova_dois.downcase == 'y'
  # cria a página para visualizar o gabarito 2
  file_text = read_file('layout/tests_show.html')
  text_to_add = "#{content_tests_show}\n      <iframe src=\"#{link_gabarito_dois}\" style=\"height: 100%; width: 100%;\"></iframe>"
  file_text.sub!(content, text_to_add)
  file_text.sub!(footer, back_button.sub('LINK', '../index.html'))
  write_file("years/#{year}/#{edition.gsub(/[^0-9A-Za-z]/, '')}/gabaritos/2/index.html", file_text)
end




