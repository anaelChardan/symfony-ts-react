module.exports = {
    // parser: 'react-eslint-parser',
    parserOptions: {
        parser: '@typescript-eslint/parser',
        project: './tsconfig.json',
        extraFileExtensions: ['.tsx'],
    },
    extends: [
        'airbnb-base',
        'plugin:import/typescript',
        'plugin:@typescript-eslint/eslint-recommended',
        'plugin:@typescript-eslint/recommended',
        'plugin:react/recommended',
        'plugin:prettier/recommended',
        'prettier/@typescript-eslint',
        'prettier/react',
    ],
    settings: {
        'import/resolver': ['node', 'webpack'],
    },
    rules: {
        'import/prefer-default-export': 'off',
        'import/extensions': [
            'error',
            'ignorePackages',
            {
                js: 'never',
                ts: 'never',
                'd.ts': 'never',
                tsx: 'never',
            },
        ],
    },
    overrides: [
        {
            files: ['*.ts', '*.tsx'],
            rules: {
                'no-useless-constructor': 'off',
                'import/extensions': [
                    'error',
                    'ignorePackages',
                    {
                        js: 'never',
                        ts: 'never',
                        'd.ts': 'never',
                        tsx: 'always',
                    },
                ],
            },
        },
    ],
};
