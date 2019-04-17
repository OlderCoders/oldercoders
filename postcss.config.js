
module.exports = {
  plugins: [
    require('postcss-import'),
    require("postcss-custom-media"),
    require('postcss-nested-ancestors'),
    require('postcss-nested'),
    require('postcss-custom-properties')({
      importFrom: [
        'frontend/config/vars.css'
      ],
      preserve: false
    }),
    require("postcss-color-function"),
    require('postcss-flexbugs-fixes'),
    require('postcss-preset-env')({
      autoprefixer: {
        flexbox: 'no-2009'
      },
      stage: 3
    })
  ]
}
