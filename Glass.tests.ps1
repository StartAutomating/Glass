describe 'Glass' {
    it 'Can read, write, and find invisible characters' {
        $HelloInvisibleWorld = ConvertTo-Glass "Hello World"

        $HelloInvisibleWorld | ConvertFrom-Glass | Should -Be "Hello World"

        $HelloInvisibleWorld > ./HelloInvisibleWorld.txt 
        
        $glassFound = Get-Item ./HelloInvisibleWorld.txt | Get-Glass
        $glassFound.Glass.Shards | ConvertFrom-Glass | Should -Be "Hello World"

        Remove-Item ./HelloInvisibleWorld.txt
    }

}
