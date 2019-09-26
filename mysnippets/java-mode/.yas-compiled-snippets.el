;;; Compiled snippets and support files for `java-mode'
;;; Snippet definitions:
;;;
(yas-define-snippets 'java-mode
                     '(("sin" "public class ${1:`(file-name-sans-extension (buffer-name))`}$2 {$0\n    private static $1 ourInstance = new $1();\n\n    public static $1 getInstance() {\n        return ourInstance;\n    }\n\n    private $1() {\n    }\n}" "Creates a Singleon class" nil nil nil "/Users/gopar/.emacs.d/mysnippets/java-mode/singleton.yasnippet" nil nil)
                       ("prefact" "import android.os.Bundle;\nimport android.preference.ListPreference;\nimport android.preference.Preference;\nimport android.preference.PreferenceActivity;\nimport android.preference.PreferenceManager;\n\n/**\n * A {@link PreferenceActivity} that presents a set of application settings.\n * <p>\n * See <a href=\"http://developer.android.com/design/patterns/settings.html\">\n * Android Design: Settings</a> for design guidelines and the <a\n * href=\"http://developer.android.com/guide/topics/ui/settings.html\">Settings\n * API Guide</a> for more information on developing a Settings UI.\n */\npublic class SettingsActivity extends PreferenceActivity\n    implements Preference.OnPreferenceChangeListener {\n\n    @Override\n    public void onCreate(Bundle savedInstanceState) {\n        super.onCreate(savedInstanceState);\n        // Add 'general' preferences, defined in the XML file\n        // TODO: Add preferences from XML\n\n        // For all preferences, attach an OnPreferenceChangeListener so the UI summary can be\n        // updated when the preference changes.\n        // TODO: Add preference\n    }\n\n    /**\n     * Attaches a listener so the summary is always updated with the preference value.\n     * Also fires the listener once, to initialize the summary (so it shows up before the value\n     * is changed.)\n     */\n    private void bindPreferenceSummaryToValue(Preference preference) {\n        // Set the listener to watch for value changes.\n        preference.setOnPreferenceChangeListener(this);\n\n        // Trigger the listener immediately with the preference's\n        // current value.\n        onPreferenceChange(\n            preference, PreferenceManager\n            .getDefaultSharedPreferences(preference.getContext())\n            .getString(preference.getKey(), \"\"));\n    }\n\n    @Override\n    public boolean onPreferenceChange(Preference preference, Object value) {\n        String stringValue = value.toString();\n\n        if (preference instanceof ListPreference) {\n            // For list preferences, look up the correct display value in\n            // the preference's 'entries' list (since they have separate labels/values).\n            ListPreference listPreference = (ListPreference) preference;\n            int prefIndex = listPreference.findIndexOfValue(stringValue);\n            if (prefIndex >= 0) {\n                preference.setSummary(listPreference.getEntries()[prefIndex]);\n            }\n        } else {\n            // For other preferences, set the summary to the value's simple string representation.\n            preference.setSummary(stringValue);\n        }\n        return true;\n    }\n\n}\n" "Creates Settings class from PreferenceActivity" nil nil nil "/Users/gopar/.emacs.d/mysnippets/java-mode/preference_activity.yasnippet" nil nil)
                       ("awf" "import android.os.Bundle;\nimport android.app.Fragment;\nimport android.app.Activity;\nimport android.view.LayoutInflater;\nimport android.view.Menu;\nimport android.view.MenuItem;\nimport android.view.View;\nimport android.view.ViewGroup;\n\npublic class ${1:`(file-name-sans-extension (buffer-name))`} extends Activity {\n\n    @Override\n    protected void onCreate(Bundle savedInstanceState) {\n        super.onCreate(savedInstanceState);\n        // TODO: Create layout file for class\n        setContentView(R.layout.);\n        if (savedInstanceState == null) {\n            getFragmentManager().beginTransaction()\n                    .add(R.id.container, new $2())\n                    .commit();\n        }\n    }\n\n    @Override\n    public boolean onCreateOptionsMenu(Menu menu) {\n        // Inflate the menu; this adds items to the action bar if it is present.\n        // TODO: Create menu file for class\n        getMenuInflater().inflate(R.menu., menu);\n        return true;\n    }\n\n    @Override\n    public boolean onOptionsItemSelected(MenuItem item) {\n        // Handle action bar item clicks here. The action bar will\n        // automatically handle clicks on the Home/Up button, so long\n        // as you specify a parent activity in AndroidManifest.xml.\n        int id = item.getItemId();\n\n        //noinspection SimplifiableIfStatement\n        if (id == R.id.action_settings) {\n            return true;\n        }\n\n        return super.onOptionsItemSelected(item);\n    }\n\n    /**\n     * A placeholder fragment containing a simple view.\n     */\n    public static class ${2:PlaceholderFragment} extends Fragment {\n\n        public $2() {\n        }\n\n        @Override\n        public View onCreateView(LayoutInflater inflater, ViewGroup container,\n                                 Bundle savedInstanceState) {\n\n            // TODO: Create layout fragment file for class\n            View rootView = inflater.inflate(R.layout.fragment_, container, false);\n            return rootView;\n        }\n    }\n}" "Activity with fragment" nil nil nil "/Users/gopar/.emacs.d/mysnippets/java-mode/activity_with_fragment.yasnippet" nil nil)))


;;; Do not edit! File generated at Fri Jan  5 17:58:00 2018
