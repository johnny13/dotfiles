<?php
function adminer_object() {
    // required to run any plugin
    include_once "./plugins/plugin.php";
    
    // autoloader
    foreach (glob("plugins/*.php") as $filename) {
        include_once "./$filename";
    }

	// new AdminerDesigns("hydra"),
    // new AdminerDatabaseHide,
    // new AdminerLoginServers,
    // new AdminerPrettyJsonColumn,
    
    $plugins = array(
        // specify enabled plugins here
        
        new AdminerFileUpload("data/"),
        new AdminerDumpAlter,
        new AdminerDumpZip,
        new AdminerDumpJson,
        new AdminerEnumOption,
        new AdminerFileUpload,
        
        new AdminerWymeditor,
        new AdminerRestoreMenuScroll,
        new AdminerColorfields
    );
    
    /* It is possible to combine customization and plugins:
    class AdminerCustomization extends AdminerPlugin {
    }
    return new AdminerCustomization($plugins);
    */
    
    return new AdminerPlugin($plugins);
}

// include original Adminer or Adminer Editor
include "./adminer.php";
?>
