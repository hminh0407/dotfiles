Search for line with odd/even number
```
\n[123456789]\+\d*[02468]\n
* \n            : start with new line
* [123456789]\+ : any number except 0 (at least 1)
* \d*           : any number
* [02468]       : any defined number
* \n            : new line

this regex come in handy when finding line that has odd/even number
especially in srt file

Take example below

14 <-- cursor jump here
00:00:47,370 --> 00:00:47,380
abc xyz subtitles

16 <-- cursor jump here
00:00:49,830 --> 00:00:49,840
abc xyz subtitles

3308 <-- cursor jump here
01:27:33,650 --> 01:27:33,660

3310 <-- cursor jump here
01:27:42,800 --> 01:27:42,810

```

