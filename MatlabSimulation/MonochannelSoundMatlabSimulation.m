clc
close all
clear all

[snd, fs, nBits] = wavread('deneme48kHz.wav');
size(snd);
% channel1  = snd(:,1); 
% lengthofChannel1 = length(channel1);% usign first channel
% channel2 = snd(:,2);
w= 4e3;
fm=w;
Ts = 1/fs;
audioInput=resample(snd,1,8);
numberofSamples = length(audioInput);
fc = 3e4;
% audioInput = channel1(1:1000);
% audioInput = snd(1000:1500);
t = Ts:Ts:(numberofSamples*Ts);
%sound(audioInput, fs, nBits);

firstSignalProducer = cos(2*pi*(w/2)*t);
firstSignalProducerPhased = sin(2*pi*(w/2)*t);

length(audioInput);
length(firstSignalProducer);

firstMixerOutput = audioInput .* firstSignalProducer'; 
secondMixerOutput = audioInput .* firstSignalProducerPhased';  

secondSignalProducer = cos(2*pi*((w/2)+fc)*t);
secondSignalProducerPhased = sin(2*pi*((w/2)+fc)*t);

wn= 2*fm/fs;
numeratorofFilter = fir1(100,wn);
freqz(numeratorofFilter);

lowPassFilterFirstOutput = filter(numeratorofFilter,1,firstMixerOutput);
lowPassFilterSecondOutput = filter(numeratorofFilter,1,secondMixerOutput);
length(lowPassFilterFirstOutput)
length(secondSignalProducer)
length(secondSignalProducerPhased)

thirdMixerOutput = lowPassFilterFirstOutput.*secondSignalProducer';
fourthMixerOutput = lowPassFilterSecondOutput.*secondSignalProducerPhased';

USB= thirdMixerOutput+fourthMixerOutput;
LSB= thirdMixerOutput-fourthMixerOutput;

%DEMODULATION PART
deFirstMixerOutput = USB * secondSignalProducer;
deSecondMixerOutput = USB * secondSignalProducerPhased;

deFirstFilterOutput = filter(numeratorofFilter,1,deFirstMixerOutput);
deSecondFilterOutput = filter(numeratorofFilter,1,deSecondMixerOutput);

deThirdMixerOutput = deFirstFilterOutput * firstSignalProducer.';
deFourthMixerOutput = deSecondFilterOutput * firstSignalProducer.';

deUSB = deThirdMixerOutput+deFourthMixerOutput;
lengthofDeUSB = length(deUSB);
%DEMODULATION PART
sound(deUSB, fs, nBits);
figure
plot(audioInput)
title('Input of The Plot')

figure
plot(deUSB)
title('Output of The Plot')
sound(audioInput, fs, nBits)

lengthofAudioInput = length(audioInput);
lengthofFirstMixerOutput = length(firstMixerOutput);
lengthofSecondMixerOutput = length(secondMixerOutput);
lengthofUSB = length(USB);
lengthofLSB = length(LSB);

NFFTofUSB = 2^nextpow2(lengthofUSB); 
fftofUSB = fft(USB,NFFTofUSB)/lengthofUSB;
fofUSB = fs/2*linspace(0,1,NFFTofUSB/2+1);

% Plot single-sided amplitude spectrum.
% figure
% plot(fofUSB,2*abs(fftofUSB(1:(NFFTofUSB/2)+1))) 
% title('Single-Sided Amplitude Spectrum of USB')

% NFFTofChannel1 = 2^nextpow2(lengthofChannel1); 
% fftofChannel1 = fft(channel1,NFFTofChannel1)/lengthofChannel1;
% fofChannel1 = fs/2*linspace(0,1,NFFTofChannel1/2+1);

% Plot single-sided amplitude spectrum.
% figure
% plot(fofChannel1,2*abs(fftofChannel1(1:(NFFTofChannel1/2)+1))) 
% title('Single-Sided Amplitude Spectrum of Deneme Ses Kayit')

% sound(snd, fs, nBits); 