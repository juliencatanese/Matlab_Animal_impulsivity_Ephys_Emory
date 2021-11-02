figure,
subplot(1,2,1)
hold on, plot(X, abs(mean(dzSMA(ipsi_dz & ~contra_dz,:))))
hold on, plot(X, abs(mean(dzSMA(~ipsi_dz & contra_dz,:))))
hold on, plot(X, abs(mean(dzSMA(ipsi_dz & contra_dz,:))))
hold on, plot(X, abs(mean(dzSMA(~ipsi_dz & ~contra_dz,:))))
subplot(1,2,2)
hold on, plot(X, mean(dzSMA(ipsi_dz & ~contra_dz,:)))
hold on, plot(X, mean(dzSMA(~ipsi_dz & contra_dz,:)))
hold on, plot(X, mean(dzSMA(ipsi_dz & contra_dz,:)))
hold on, plot(X, mean(dzSMA(~ipsi_dz & ~contra_dz,:)))
figure,
hold on, plot(X, abs(mean(dzSMA(contra_dz,:))))
hold on, plot(X, abs(mean(dzSMA(ipsi_dz,:))))
hold on, plot(X, abs(mean(dzSMA(contra_dz & Tdz_LR.Opto_inib,:))))
hold on, plot(X, abs(mean(dzSMA(ipsi_dz & Tdz_LR.Opto_inib,:))))
legend('cont','ipsi','opto contra', 'opto ipsi','Location','northwest' )

figure,
subplot(3,1,1)
hold on, plot(X, abs(mean(dzSMA(contra_dz & (Tcombo_z.z_exct_UniMod_3res | Tcombo_z.z_exct_biMod_23dr | Tcombo_z.z_exct_triMod_123) ,:))))
hold on, plot(X, abs(mean(dzSMA(ipsi_dz & (Tcombo_z.z_exct_UniMod_3res | Tcombo_z.z_exct_biMod_23dr | Tcombo_z.z_exct_triMod_123),:))))
hold on, plot(X, abs(mean(dzSMA(contra_dz & (Tcombo_z.z_exct_UniMod_1puf | Tcombo_z.z_exct_biMod_12pd | Tcombo_z.z_exct_triMod_123) ,:))))
hold on, plot(X, abs(mean(dzSMA(ipsi_dz & (Tcombo_z.z_exct_UniMod_1puf | Tcombo_z.z_exct_biMod_12pd | Tcombo_z.z_exct_triMod_123),:))))
legend('res cont all',' res ipsi all',' puf cont all' , 'puf ipsi all','Location','northwest')
subplot(3,1,2)
hold on, plot(X, abs(mean(dzSMA(contra_dz &  Tcombo_z.z_exct_triMod_123,:))))
hold on, plot(X, abs(mean(dzSMA(ipsi_dz &  Tcombo_z.z_exct_triMod_123,:))))
legend('TRI cont','TRI ipsi')
subplot(3,1,3)
hold on, plot(X, abs(mean(dzSMA(contra_dz & (Tcombo_z.z_exct_UniMod_3res | Tcombo_z.z_exct_biMod_23dr),:))))
hold on, plot(X, abs(mean(dzSMA(ipsi_dz & (Tcombo_z.z_exct_UniMod_3res | Tcombo_z.z_exct_biMod_23dr),:))))
hold on, plot(X, abs(mean(dzSMA(contra_dz & (Tcombo_z.z_exct_UniMod_1puf | Tcombo_z.z_exct_biMod_12pd),:))))
hold on, plot(X, abs(mean(dzSMA(ipsi_dz & (Tcombo_z.z_exct_UniMod_1puf | Tcombo_z.z_exct_biMod_12pd),:))))
legend('res cont (not tri)',' res ipsi (not tri)',' puf cont (not tri)' , 'puf ipsi (not tri)','Location','northwest')

figure,
subplot(4,1,1)
hold on, plot(X, abs(mean(dzSMA(contra_dz & Tcombo_z.z_exct_pufAll,:))))
hold on, plot(X, abs(mean(dzSMA(ipsi_dz   & Tcombo_z.z_exct_pufAll,:))))
legend('contra puf all',' ipsi puf all','Location','northwest')
subplot(4,1,2)
hold on, plot(X, abs(mean(dzSMA(contra_dz & Tcombo_z.z_exct_delAll,:))))
hold on, plot(X, abs(mean(dzSMA(ipsi_dz   & Tcombo_z.z_exct_delAll,:))))
legend('contra del all',' ipsi del all','Location','northwest')
subplot(4,1,3)
hold on, plot(X, abs(mean(dzSMA(contra_dz & Tcombo_z.z_exct_resAll,:))))
hold on, plot(X, abs(mean(dzSMA(ipsi_dz   & Tcombo_z.z_exct_resAll,:))))
legend('contra res all',' ipsi res all','Location','northwest')
subplot(4,1,4)
hold on, plot(X, abs(mean(dzSMA(contra_dz & Tcombo_z.z_nosig,:))))
hold on, plot(X, abs(mean(dzSMA(ipsi_dz   & Tcombo_z.z_nosig,:))))
legend('contra no sig all',' ipsi nosig all','Location','northwest')