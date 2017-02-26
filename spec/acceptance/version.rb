
_osfamily               = fact('osfamily')
_operatingsystem        = fact('operatingsystem')
_operatingsystemrelease = fact('operatingsystemrelease').to_f

case _osfamily
when 'RedHat'
  $examplevar = 'valrh'

when 'Debian'
  $examplevar = 'valdeb'

else
  $examplevar = '-_-'

end
