// Races data
const Map<String, Map<String, dynamic>> defaultRaces = {
  'Людина': {
    'description': 'Адаптивні та амбітні',
    'abilityScoreIncrease': {'Сила': 1, 'Спритність': 1, 'Статура': 1, 'Інтелект': 1, 'Мудрість': 1, 'Харизма': 1},
  },
  'Ельф': {
    'description': 'Граціозні та довговічні',
    'abilityScoreIncrease': {'Спритність': 2},
  },
  'Дварф': {
    'description': 'Міцні та витривалі',
    'abilityScoreIncrease': {'Статура': 2},
  },
  'Напіврослик': {
    'description': 'Швидкі та везучі',
    'abilityScoreIncrease': {'Спритність': 2},
  },
  'Гном': {
    'description': 'Хитрі та винахідливі',
    'abilityScoreIncrease': {'Інтелект': 2},
  },
  'Тифлінг': {
    'description': 'Пекельні нащадки',
    'abilityScoreIncrease': {'Інтелект': 1, 'Харизма': 2},
  },
  'Драконороджений': {
    'description': 'Спадкоємці драконів',
    'abilityScoreIncrease': {'Сила': 2, 'Харизма': 1},
  },
  'Напівельф': {
    'description': 'Змішана спадщина',
    'abilityScoreIncrease': {'Харизма': 2},
  },
};