module.exports = {
  root: true,
  env: { browser: true, es2020: true },
  extends: [
    'eslint:recommended',
    'plugin:@typescript-eslint/recommended',
    'plugin:react-hooks/recommended',
    'plugin:prettier/recommended',
  ],
  ignorePatterns: ['dist', '.eslintrc.cjs'],
  parser: '@typescript-eslint/parser',
  plugins: ['react-refresh', 'prettier', '@stylistic'],
  rules: {
    'react-refresh/only-export-components': [
      'warn',
      { allowConstantExport: true },
    ],
    'no-console': 'warn',
    'arrow-body-style': ['error', 'as-needed'],
    'no-duplicate-imports': 'error',
    'array-callback-return': 'error',
    '@typescript-eslint/array-type': 'error',
    'prettier/prettier': [
      'error',
      {
        endOfLine: 'auto',
      },
    ],

    // Deprecated from eslint
    '@stylistic/semi': ['error', 'always'],
    '@stylistic/block-spacing': 'error',
    '@stylistic/no-trailing-spaces': ['error', { ignoreComments: true }],
  },
};
