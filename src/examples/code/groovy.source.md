```` groovy
#!/usr/bin/env groovy
package model

import groovy.transform.CompileStatic
import java.util.List as MyList

trait Distributable {
    void distribute(String version) {}
}

@CompileStatic
class Distribution implements Distributable {
    double number = 1234.234 / 567
    def otherNumber = 3 / 4
    boolean archivable = condition ?: true
    def ternary = a ? b : c
    String name = "Guillaume"
    Closure description = null
    List<DownloadPackage> packages = []
    String regex = ~/.*foo.*/
    String multi = '''
        multi line string
    ''' + """
        now with double quotes and ${gstring}
    """ + $/
        even with dollar slashy strings
    /$

    /**
     * description method
     * @param cl the closure
     */
    void description(Closure cl) { this.description = cl }

    void version(String name, Closure versionSpec) {
        def closure = { println "hi" } as Runnable

        MyList ml = [1, 2, [a: 1, b:2,c :3]]
        for (ch in "name") {}

        // single line comment
        DownloadPackage pkg = new DownloadPackage(version: name)

        check that: true

        label:
        def clone = versionSpec.rehydrate(pkg, pkg, pkg)
        /*
            now clone() in a multiline comment
        */
        clone()
        packages.add(pkg)

        assert 4 / 2 == 2
    }
}
````