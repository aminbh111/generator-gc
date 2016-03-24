'use strict';
var util = require('util'),
    path = require('path'),
    generators = require('yeoman-generator'),
    chalk = require('chalk'),
    _ = require('lodash'),
    scriptBase = require('../generator-base');

const constants = require('../generator-constants'),
    CLIENT_MAIN_SRC_DIR = constants.CLIENT_MAIN_SRC_DIR,
    SERVER_MAIN_SRC_DIR = constants.SERVER_MAIN_SRC_DIR,
    SERVER_MAIN_RES_DIR = constants.SERVER_MAIN_RES_DIR;

var ModulesGenerator = generators.Base.extend({});

util.inherits(ModulesGenerator, scriptBase);

module.exports = ModulesGenerator.extend({
    constructor: function () {
        generators.Base.apply(this, arguments);

        var greencodeVar = this.options.greencodeVar;
        var greencodeFunc = this.options.greencodeFunc;
        if (greencodeVar == null || greencodeVar.moduleName == null) {
            this.env.error(chalk.red('ERROR! This sub-generator must be used by Greencode modules, and the module name is not defined.'));
        }

        this.log('Composing Greencode configuration with module ' + chalk.red(greencodeVar.moduleName));

        var baseName = this.config.get('baseName');
        var packageName = this.config.get('packageName');
        var packageFolder = this.config.get('packageFolder');

        if (!this.options.skipValidation && (baseName == null || packageName == null)) {
            this.log(chalk.red('ERROR! There is no existing Greencode configuration file in this directory.'));
            this.env.error('Greencode ' + greencodeVar.moduleName + ' is a Greencode module, and needs a .yo-rc.json configuration file made by Greencode.');
        }
        // add required Greencode variables
        greencodeVar['baseName'] = this.baseName = baseName;
        greencodeVar['packageName'] = packageName;
        greencodeVar['packageFolder'] = packageFolder;

        greencodeVar['authenticationType'] = this.config.get('authenticationType');
        greencodeVar['hibernateCache'] = this.config.get('hibernateCache');
        greencodeVar['clusteredHttpSession'] = this.config.get('clusteredHttpSession');
        greencodeVar['websocket'] = this.config.get('websocket');
        greencodeVar['databaseType'] = this.config.get('databaseType');
        greencodeVar['devDatabaseType'] = this.config.get('devDatabaseType');
        greencodeVar['prodDatabaseType'] = this.config.get('prodDatabaseType');
        greencodeVar['searchEngine'] = this.config.get('searchEngine');
        greencodeVar['useSass'] = this.config.get('useSass');
        greencodeVar['buildTool'] = this.config.get('buildTool');
        greencodeVar['enableTranslation'] = this.config.get('enableTranslation');
        greencodeVar['nativeLanguage'] = this.config.get('nativeLanguage');
        greencodeVar['languages'] = this.config.get('languages');
        greencodeVar['enableSocialSignIn'] = this.config.get('enableSocialSignIn');
        greencodeVar['testFrameworks'] = this.config.get('testFrameworks');

        greencodeVar['angularAppName'] = this.getAngularAppName();
        greencodeVar['mainClassName'] = this.getMainClassName();
        greencodeVar['javaDir'] = SERVER_MAIN_SRC_DIR + packageFolder + '/';
        greencodeVar['resourceDir'] = SERVER_MAIN_RES_DIR;
        greencodeVar['webappDir'] = CLIENT_MAIN_SRC_DIR;
        greencodeVar['CONSTANTS'] = constants;

        // alias fs and log methods so that we can use it in script-base when invoking functions from greencodeFunc context in modules
        greencodeFunc['fs'] = this.fs;
        greencodeFunc['log'] = this.log;

        //add common methods from script-base.js
        greencodeFunc['addSocialButton'] = this.addSocialButton;
        greencodeFunc['addSocialConnectionFactory'] = this.addSocialConnectionFactory;
        greencodeFunc['addMavenDependency'] = this.addMavenDependency;
        greencodeFunc['addMavenPlugin'] = this.addMavenPlugin;
        greencodeFunc['addGradlePlugin'] = this.addGradlePlugin;
        greencodeFunc['addGradleDependency'] = this.addGradleDependency;
        greencodeFunc['addSocialConfiguration'] = this.addSocialConfiguration;
        greencodeFunc['applyFromGradleScript'] = this.applyFromGradleScript;
        greencodeFunc['addBowerrcParameter'] = this.addBowerrcParameter;
        greencodeFunc['addBowerDependency'] = this.addBowerDependency;
        greencodeFunc['addBowerOverride'] = this.addBowerOverride;
        greencodeFunc['addMainCSSStyle'] = this.addMainCSSStyle;
        greencodeFunc['addMainSCSSStyle'] = this.addMainSCSSStyle;
        greencodeFunc['addAngularJsModule'] = this.addAngularJsModule;
        greencodeFunc['addAngularJsInterceptor'] = this.addAngularJsInterceptor;
        greencodeFunc['addMessageformatLocaleToBowerOverride'] = this.addMessageformatLocaleToBowerOverride;
        greencodeFunc['addElementToMenu'] = this.addElementToMenu;
        greencodeFunc['addElementToAdminMenu'] = this.addElementToAdminMenu;
        greencodeFunc['addEntityToMenu'] = this.addEntityToMenu;
        greencodeFunc['addElementTranslationKey'] = this.addElementTranslationKey;
        greencodeFunc['addAdminElementTranslationKey'] = this.addAdminElementTranslationKey;
        greencodeFunc['addGlobalTranslationKey'] = this.addGlobalTranslationKey;
        greencodeFunc['addTranslationKeyToAllLanguages'] = this.addTranslationKeyToAllLanguages;
        greencodeFunc['getAllSupportedLanguages'] = this.getAllSupportedLanguages;
        greencodeFunc['getAllSupportedLanguageOptions'] = this.getAllSupportedLanguageOptions;
        greencodeFunc['isSupportedLanguage'] = this.isSupportedLanguage;
        greencodeFunc['getAllInstalledLanguages'] = this.getAllInstalledLanguages;
        greencodeFunc['addEntityTranslationKey'] = this.addEntityTranslationKey;
        greencodeFunc['addChangelogToLiquibase'] = this.addChangelogToLiquibase;
        greencodeFunc['addColumnToLiquibaseEntityChangeset'] = this.addColumnToLiquibaseEntityChangeset;
        greencodeFunc['dateFormatForLiquibase'] = this.dateFormatForLiquibase;
        greencodeFunc['copyI18nFilesByName'] = this.copyI18nFilesByName;
        greencodeFunc['copyTemplate'] = this.copyTemplate;
        greencodeFunc['copyHtml'] = this.copyHtml;
        greencodeFunc['copyJs'] = this.copyJs;
        greencodeFunc['rewriteFile'] = this.rewriteFile;
        greencodeFunc['replaceContent'] = this.replaceContent;
        greencodeFunc['registerModule'] = this.registerModule;
        greencodeFunc['updateEntityConfig'] = this.updateEntityConfig;
        greencodeFunc['getModuleHooks'] = this.getModuleHooks;
        greencodeFunc['getExistingEntities'] = this.getExistingEntities;

    },

    initializing: function () {
        //at least one method is required for yeoman to initilize the generator
        this.log('Reading the Greencode project configuration for your module');
    }
});
