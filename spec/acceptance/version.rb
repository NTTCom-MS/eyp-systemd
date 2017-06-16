
_osfamily               = fact('osfamily')
_operatingsystem        = fact('operatingsystem')
_operatingsystemrelease = fact('operatingsystemrelease').to_f

$examplevar = case _osfamily
  when 'RedHat'
    'valrh'

  when 'Debian'
    'valdeb'

  else
    '-_-'
end
